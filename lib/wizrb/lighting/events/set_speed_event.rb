# frozen_string_literal: true

require_relative 'event'

module Wizrb
  module Lighting
    module Events
      class SetSpeedEvent < Wizrb::Lighting::Events::Event
        MIN_VALUE = 10
        MAX_VALUE = 200

        def initialize(value)
          validate!(value)
          super(method: 'setState', params: { speed: value })
        end

        private

        def validate!(value)
          return if value && value >= MIN_VALUE && value <= MAX_VALUE

          raise ArgumentError, "Speed must be between #{MIN_VALUE} and #{MAX_VALUE}"
        end
      end
    end
  end
end
