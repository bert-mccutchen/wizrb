# frozen_string_literal: true

module Wizrb
  module Lighting
    module Products
      class TunableBulb
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
      end
    end
  end
end
