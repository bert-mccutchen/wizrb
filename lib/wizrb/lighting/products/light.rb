# frozen_string_literal: true

require 'json'
require 'socket'
require 'timeout'
require_relative '../../shared/products/device'
require_relative '../state'

module Wizrb
  module Lighting
    module Products
      class Light < Wizrb::Shared::Products::Device
        def initialize(ip:, port: 38_899)
          super(ip: ip, port: port, state: Wizrb::Lighting::State.new)
        end

        def white_range
          @white_range ||=
            user_config&.dig('whiteRange') ||
            model_config&.dig('extRange') ||
            model_config&.dig('cctRange') ||
            user_config&.dig('extRange') ||
            user_config&.dig('cctRange')
        end

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
end
