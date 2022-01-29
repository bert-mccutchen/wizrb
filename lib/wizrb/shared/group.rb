# frozen_string_literal: true

require_relative 'events/base'
require_relative 'events/power_event'
require_relative 'events/reboot_event'
require_relative 'events/refresh_event'
require_relative 'events/reset_event'

module Wizrb
  module Shared
    class Group
      include Enumerable

      attr_reader :devices

      def initialize(devices:)
        @devices = devices
      end

      def each(&block)
        @devices.each(&block)
      end

      def power_on
        dispatch_event(Wizrb::Shared::Events::PowerEvent.new(true))
      end

      def power_off
        dispatch_event(Wizrb::Shared::Events::PowerEvent.new(false))
      end

      def reboot
        dispatch_event(Wizrb::Shared::Events::RebootEvent.new)
      end

      def reset
        dispatch_event(Wizrb::Shared::Events::ResetEvent.new)
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

      def dispatch(event)
        @devices.each do |light|
          light.dispatch_event(event)
        end
      end
    end
  end
end
