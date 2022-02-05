# frozen_string_literal: true

require_relative '../shared/group'

module Wizrb
  module Lighting
    class Group < Wizrb::Shared::Group
      def brightness(value)
        dispatch_event(Wizrb::Lighting::Events::SetBrightnessEvent.new(value))
      end

      def cold_white(value)
        dispatch_event(Wizrb::Lighting::Events::SetColdWhiteEvent.new(value))
      end

      def color_temp(value)
        dispatch_event(Wizrb::Lighting::Events::SetColorTempEvent.new(value))
      end

      def rgb(red, green, blue)
        dispatch_event(Wizrb::Lighting::Events::SetRgbEvent.new(red, green, blue))
      end

      def speed(value)
        dispatch_event(Wizrb::Lighting::Events::SetSpeedEvent.new(value))
      end

      def warm_white(value)
        dispatch_event(Wizrb::Lighting::Events::SetWarmWhiteEvent.new(value))
      end

      def scene(value)
        dispatch_event(Wizrb::Lighting::Events::SetSceneEvent.new(value))
      end
    end
  end
end
