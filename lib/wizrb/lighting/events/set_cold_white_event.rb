# frozen_string_literal: true

require_relative "../../shared/events/base"

module Wizrb
  module Lighting
    module Events
      class SetColdWhiteEvent < Wizrb::Shared::Events::Base
        MIN_VALUE = 1
        MAX_VALUE = 255

        def initialize(value)
          validate!(value)
          super(method: "setState", params: {c: value})
        end

        private

        def validate!(value)
          return if value && value >= MIN_VALUE && value <= MAX_VALUE

          raise ArgumentError, "Cold white must be between #{MIN_VALUE} and #{MAX_VALUE}"
        end
      end
    end
  end
end
