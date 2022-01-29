# frozen_string_literal: true

require_relative '../../shared/events/base'

module Wizrb
  module Lighting
    module Events
      class SetRgbEvent < Wizrb::Shared::Events::Base
        MIN_VALUE = 1
        MAX_VALUE = 255

        def initialize(red, green, blue)
          validate_color!('Red', red)
          validate_color!('Green', green)
          validate_color!('Blue', blue)
          super(method: 'setState', params: { r: red, g: green, b: blue })
        end

        private

        def validate_color!(color, value)
          return if value && value >= MIN_VALUE && value <= MAX_VALUE

          raise ArgumentError, "#{color} must be between #{MIN_VALUE} and #{MAX_VALUE}"
        end
      end
    end
  end
end
