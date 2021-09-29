# frozen_string_literal: true

require_relative 'light'

module Wizrb
  module Lighting
    module Products
      class TunableLight < Wizrb::Lighting::Products::Light
        FEATURES = {
          brightness: true,
          color_temp: true,
          color: false,
          effect: true,
          scenes: %i[
            cozy
            wake_up
            bedtime
            warm_white
            daylight
            cool_white
            night_light
            focus
            relax
            tv_time
            candlelight
            golden_white
            pulse
            steampunk
          ]
        }.freeze

        def initialize(ip:, port: 38_899)
          super
        end
      end
    end
  end
end
