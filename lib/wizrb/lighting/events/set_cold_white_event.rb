# frozen_string_literal: true

require_relative 'event'

module Wizrb
  module Lighting
    module Events
      class SetColdWhiteEvent < Wizrb::Lighting::Events::Event
        def initialize(value)
          validate!(value)
          super(method: 'setState', params: { c: value })
        end

        private

        def validate!(value)
          raise ArgumentError, 'Cold white must be between 1 and 255' if !value || value < 1 || value > 255
        end
      end
    end
  end
end
