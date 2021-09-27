# frozen_string_literal: true

module Wizrb
  module Lighting
    module Products
      class DimableBulb
        FEATURES = {
          brightness: true,
          color_temp: false,
          color: false,
          effect: false,
          scenes: %i[
            wake_up
            bedtime
            cool_white
            night_light
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
