# frozen_string_literal: true

require_relative 'products/light'

module Wizrb
  module Lighting
    class Group
      include Enumerable

      attr_reader :lights

      def initialize(lights:)
        @lights = lights
      end

      def each(&block)
        @lights.each(&block)
      end

      def power_on
        dispatch_event(Wizrb::Lighting::Events::PowerEvent.new(true))
      end

      def power_off
        dispatch_event(Wizrb::Lighting::Events::PowerEvent.new(false))
      end

      def reboot
        dispatch_event(Wizrb::Lighting::Events::RebootEvent.new)
      end

      def reset
        dispatch_event(Wizrb::Lighting::Events::ResetEvent.new)
      end

      def dispatch_event(event)
        unless event.is_a?(Wizrb::Lighting::Events::Event)
          raise ArgumentError, 'Not an instance of Wizrb::Lighting::Events::Event'
        end

        dispatch_event_each(event)
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

      def dispatch_event_each(event)
        @lights.each do |light|
          light.dispatch_event(event)
        end
      end
    end
  end
end
