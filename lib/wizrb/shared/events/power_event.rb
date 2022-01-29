# frozen_string_literal: true

require_relative 'base'

module Wizrb
  module Shared
    module Events
      class PowerEvent < Wizrb::Shared::Events::Base
        def initialize(value)
          validate!(value)
          super(method: 'setPilot', params: { state: value })
        end

        private

        def validate!(value)
          raise ArgumentError, 'Power state must be a boolean' unless [true, false].include?(value)
        end
      end
    end
  end
end
