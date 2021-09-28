# frozen_string_literal: true

require_relative 'event'

module Wizrb
  module Lighting
    module Events
      class SetSceneEvent < Wizrb::Lighting::Events::Event
        def initialize(value)
          validate!(value)
          super(method: 'setState', params: { sceneId: Wizrb::Lighting::SCENES[value] })
        end

        private

        def validate!(value)
          raise ArgumentError, 'Invalid scene' unless Wizrb::Lighting::SCENES.include?(value)
        end
      end
    end
  end
end
