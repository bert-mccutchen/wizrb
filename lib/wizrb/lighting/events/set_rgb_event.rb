# frozen_string_literal: true

require_relative 'event'

module Wizrb
  module Lighting
    module Events
      class SetRgbEvent < Wizrb::Lighting::Events::Event
        def initialize(red, green, blue)
          validate_color!('Red', red)
          validate_color!('Green', green)
          validate_color!('Blue', blue)
          super(method: 'setState', params: { r: red, g: green, b: blue })
        end

        private

        def validate_color!(color, value)
          raise ArgumentError, "#{color} must be between 0 and 255" if !value || value < 0 || value > 255
        end
      end
    end
  end
end
