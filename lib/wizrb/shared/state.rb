# frozen_string_literal: true

module Wizrb
  module Shared
    class State
      STATE_KEYS = %i[state].freeze

      def initialize
        @state = {state: false}
      end

      def parse!(response)
        result = response&.dig("result")
        return unless result

        @state = result.transform_keys(&:to_sym).slice(*STATE_KEYS)
      end

      def power
        @state[:state]
      end

      def to_s
        @state.to_s
      end

      def to_json(*_args)
        @state.to_json
      end
    end
  end
end
