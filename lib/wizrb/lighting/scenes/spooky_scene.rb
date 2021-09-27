# frozen_string_literal: true

require_relative 'scene'

module Wizrb
  module Lighting
    module Scenes
      class SpookyScene < Wizrb::Lighting::Scenes::Scene
        DEFAULT_STATE_EVENTS = [
          Wizrb::Lighting::Events::PowerEvent.new(true),
          Wizrb::Lighting::Events::SetSpeedEvent.new(200),
          Wizrb::Lighting::Events::SetColorTempEvent.new(1000),
          Wizrb::Lighting::Events::SetBrightnessEvent.new(100)
        ].freeze

        BLACKOUT_EVENTS = [
          Wizrb::Lighting::Events::PowerEvent.new(false)
        ].freeze

        def initialize(group, sync: false)
          @sync = sync
          super(group, stop_delay: 10)
        end

        protected

        def before_start
          dispatch(DEFAULT_STATE_EVENTS, sync: true)
        end

        def step
          if Random.rand > 0.5
            Random.rand(1..10).times do
              next if Random.rand > 0.25

              dispatch(BLACKOUT_EVENTS, sync: @sync)
              sleep(Random.rand > 0.98 ? 3 : 0.125)
              dispatch(DEFAULT_STATE_EVENTS, sync: true)
            end
          end

          sleep(Random.rand(0.125..5.0))
        end

        def after_stop
          dispatch(DEFAULT_STATE_EVENTS, sync: true)
        end

        private

        def dispatch(events, sync: false)
          if sync
            @group.dispatch_events(*events)
          else
            @group.bulbs.sample.dispatch_events(*events)
          end
        end
      end
    end
  end
end
