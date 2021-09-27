# frozen_string_literal: true

require_relative 'event'

module Wizrb
  module Lighting
    module Events
      class SetSpeedEvent < Wizrb::Lighting::Events::Event
        def initialize(value)
          validate!(value)
          super(method: 'setState', params: { speed: value })
        end

        private

        def validate!(value)
          raise ArgumentError, 'Speed must be between 10 and 200' if !value || value < 10 || value > 200
        end
      end
    end
  end
end
