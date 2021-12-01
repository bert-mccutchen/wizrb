# frozen_string_literal: true

module Wizrb
  module Lighting
    class State
      STATE_KEYS = %i[state w c r g b temp dimming speed sceneId].freeze

      def initialize
        @state = {
          state: false
        }
      end

      def parse!(response)
        result = response&.dig('result')
        return unless result

        @state = result.transform_keys(&:to_sym).slice(*STATE_KEYS)
        @state.delete(:sceneId) if @state[:sceneId].zero?
      end

      def power
        @state[:state]
      end

      def warm_white
        @state[:w]
      end

      def cold_white
        @state[:c]
      end

      def rgb
        { red: @state[:r], green: @state[:g], blue: @state[:b] }
      end

      def color_temp
        @state[:temp]
      end

      def brightness
        if @state[:dimming] < 10
          @state[:dimming].to_i * 10
        else
          @state[:dimming]
        end
      end

      def speed
        @state[:speed]
      end

      def scene
        Wizrb::Lighting::SCENES.key(@state[:schdPsetId] || @state[:sceneId])
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
