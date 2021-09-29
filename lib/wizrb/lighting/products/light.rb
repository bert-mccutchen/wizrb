# frozen_string_literal: true

require 'json'
require 'socket'
require 'timeout'
require_relative '../connection'
require_relative '../state'
require_relative '../events/event'
require_relative '../events/power_event'
require_relative '../events/reboot_event'
require_relative '../events/refresh_event'
require_relative '../events/reset_event'

module Wizrb
  module Lighting
    module Products
      class Light
        attr_reader :ip, :port, :state

        def initialize(ip:, port: 38_899)
          @ip = ip
          @port = port
          @state = Wizrb::Lighting::State.new
          @connection = Wizrb::Lighting::Connection.new(ip, port)
          @connection.test
          refresh
        end

        def system_config
          @system_config ||= dispatch({ method: 'getSystemConfig', params: {} })&.dig('result')
        end

        def model_config
          @model_config ||= dispatch({ method: 'getModelConfig', params: {} })&.dig('result')
        end

        def user_config
          @user_config ||= dispatch({ method: 'getUserConfig', params: {} })&.dig('result')
        end

        def module_name
          @module_name ||= system_config&.dig('moduleName')
        end

        def white_range
          @white_range ||=
            user_config&.dig('whiteRange') ||
            model_config&.dig('extRange') ||
            model_config&.dig('cctRange') ||
            user_config&.dig('extRange') ||
            user_config&.dig('cctRange')
        end

        def power_on
          dispatch_event(Wizrb::Lighting::Events::PowerEvent.new(true))
        end

        def power_off
          dispatch_event(Wizrb::Lighting::Events::PowerEvent.new(false))
        end

        def power_switch
          if refresh.state.power
            power_off
          else
            power_on
          end
        end

        def reboot
          dispatch_event(Wizrb::Lighting::Events::RebootEvent.new)
        end

        def reset
          dispatch_event(Wizrb::Lighting::Events::ResetEvent.new)
        end

        def refresh
          response = dispatch_event(Wizrb::Lighting::Events::RefreshEvent.new)
          state.parse!(response)
          self
        end

        def dispatch_event(event)
          unless event.is_a?(Wizrb::Lighting::Events::Event)
            raise ArgumentError, 'Not an instance of Wizrb::Lighting::Events::Event'
          end

          dispatch(event)
        end

        def dispatch_events(*events)
          events.each do |event|
            unless event.is_a?(Wizrb::Lighting::Events::Event)
              raise ArgumentError, 'Not an instance of Wizrb::Lighting::Events::Event'
            end
          end

          params = events.reduce({}) { |h, e| h.merge(e.params) }
          dispatch_event(Wizrb::Lighting::Events::Event.new(method: 'setState', params: params))
        end

        private

        def dispatch(data)
          @connection.send(data)
          @connection.recieve(timeout: 10, max: 65_536)
        end
      end
    end
  end
end
