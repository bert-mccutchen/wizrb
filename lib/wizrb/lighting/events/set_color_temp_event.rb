# frozen_string_literal: true

require_relative '../../shared/events/base'

module Wizrb
  module Lighting
    module Events
      class SetColorTempEvent < Wizrb::Shared::Events::Base
        MIN_VALUE = 1000
        MAX_VALUE = 12_000

        def initialize(value)
          validate!(value)
          super(method: 'setState', params: { temp: value })
        end

        private

        def validate!(value)
          if !value || value < MIN_VALUE || value > MAX_VALUE
            raise ArgumentError, "Temperature must be between #{MIN_VALUE} and #{MAX_VALUE} kelvin"
          end

          raise ArgumentError, 'Temperature must be divisible by 100' unless value % 100 == 0
        end
      end
    end
  end
end
