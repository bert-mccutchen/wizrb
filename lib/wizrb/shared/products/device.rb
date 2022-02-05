# frozen_string_literal: true

require 'json'
require 'socket'
require 'timeout'
require_relative '../connection'
require_relative '../state'
require_relative '../events/base'
require_relative '../events/power_event'
require_relative '../events/reboot_event'
require_relative '../events/refresh_event'
require_relative '../events/reset_event'

module Wizrb
  module Shared
    module Products
      class Device
        attr_reader :ip, :port, :state

        def initialize(ip:, port: 38_899, state: Wizrb::Shared::State.new)
          @ip = ip
          @port = port
          @state = state
          connect
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

        def power_on
          dispatch_event(Wizrb::Shared::Events::PowerEvent.new(true))
        end

        def power_off
          dispatch_event(Wizrb::Shared::Events::PowerEvent.new(false))
        end

        def power_switch
          if refresh.state.power
            power_off
          else
            power_on
          end
        end

        def reboot
          dispatch_event(Wizrb::Shared::Events::RebootEvent.new)
        end

        def reset
          dispatch_event(Wizrb::Shared::Events::ResetEvent.new)
        end

        def refresh
          response = dispatch_event(Wizrb::Shared::Events::RefreshEvent.new)
          state.parse!(response)
          self
        end

        def dispatch_event(event)
          unless event.is_a?(Wizrb::Shared::Events::Base)
            raise ArgumentError, 'Not an instance of Wizrb::Shared::Events::Base'
          end

          dispatch(event)
        end

        def dispatch_events(*events)
          events.each do |event|
            unless event.is_a?(Wizrb::Shared::Events::Base)
              raise ArgumentError, 'Not an instance of Wizrb::Shared::Events::Base'
            end
          end

          params = events.reduce({}) { |h, e| h.merge(e.params) }
          dispatch_event(Wizrb::Shared::Events::Base.new(method: 'setState', params: params))
        end

        private

        def connect
          @connection = Wizrb::Shared::Connection.new(ip, port)
          refresh
        end

        def dispatch(data)
          @connection.send(data)
          @connection.recieve(timeout: 10, max: 65_536)
        end
      end
    end
  end
end
