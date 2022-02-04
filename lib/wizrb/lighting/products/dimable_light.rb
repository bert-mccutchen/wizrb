# frozen_string_literal: true

require_relative 'light'

module Wizrb
  module Lighting
    module Products
      class DimableLight < Wizrb::Lighting::Products::Light
        MODULE_NAME_IDENTIFIER = 'DW'
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

        def initialize(ip:, port: 38_899)
          super
        end
      end
    end
  end
end
