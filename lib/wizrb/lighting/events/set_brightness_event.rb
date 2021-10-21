# frozen_string_literal: true

require_relative 'event'

module Wizrb
  module Lighting
    module Events
      class SetBrightnessEvent < Wizrb::Lighting::Events::Event
        MIN_VALUE = 10
        MAX_VALUE = 100

        def initialize(value)
          validate!(value)
          super(method: 'setState', params: { dimming: value.to_i })
        end

        private

        def validate!(value)
          return if value && value >= MIN_VALUE && value <= MAX_VALUE

          raise ArgumentError, "Brightness must be an integer between #{MIN_VALUE} and #{MAX_VALUE}"
        end
      end
    end
  end
end
