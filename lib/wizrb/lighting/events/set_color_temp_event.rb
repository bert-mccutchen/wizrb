# frozen_string_literal: true

require_relative 'event'

module Wizrb
  module Lighting
    module Events
      class SetColorTempEvent < Wizrb::Lighting::Events::Event
        def initialize(value)
          validate!(value)
          super(method: 'setState', params: { temp: value })
        end

        private

        def validate!(value)
          if !value || value < 1000 || value > 10_000
            raise ArgumentError, 'Temperature must be between 1000 and 10000 kelvin'
          end

          raise ArgumentError, 'Temperature must be divisible by 100' unless value % 100 == 0
        end
      end
    end
  end
end
