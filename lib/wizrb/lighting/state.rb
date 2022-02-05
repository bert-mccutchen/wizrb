# frozen_string_literal: true

module Wizrb
  module Lighting
    class State < Wizrb::Shared::State
      STATE_KEYS = %i[state w c r g b temp dimming speed sceneId].freeze

      def parse!(response)
        result = response&.dig('result')
        return unless result

        @state = result.transform_keys(&:to_sym).slice(*STATE_KEYS)
        @state.delete(:sceneId) if @state[:sceneId]&.zero?
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
        @state[:dimming]
      end

      def speed
        @state[:speed]
      end

      def scene
        Wizrb::Lighting::SCENES.key(@state[:schdPsetId] || @state[:sceneId])
      end
    end
  end
end
