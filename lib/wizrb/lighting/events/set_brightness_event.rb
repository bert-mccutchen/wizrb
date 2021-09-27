# frozen_string_literal: true

require_relative 'event'

module Wizrb
  module Lighting
    module Events
      class SetBrightnessEvent < Wizrb::Lighting::Events::Event
        def initialize(value)
          validate!(value)
          super(method: 'setState', params: { dimming: ((value / 255.0) * 100).round })
        end

        private

        def validate!(value)
          raise ArgumentError, 'Brightness must be between 10 and 255' if !value || value < 10 || value > 255
        end
      end
    end
  end
end
