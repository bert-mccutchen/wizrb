# frozen_string_literal: true

require_relative "../group"

module Wizrb
  module Lighting
    module Scenes
      class Scene
        def initialize(group, stop_delay: 1, save: true)
          validate!(group)
          @group = group
          @stop_delay = stop_delay
          @save = save
          @running = false
          @thread = nil
        end

        def start
          @running = true
          @thread = Thread.new do
            save_state if @save
            before_start
            step while @running
            after_stop
          ensure
            restore_state if @save
          end
        end

        def stop
          @running = false
          sleep(@stop_delay)
          @thread.terminate
        end

        protected

        def before_start
        end

        def step
          raise Wizrb::Error, "You failed to implement #step on your scene"
        end

        def after_stop
        end

        private

        def validate!(value)
          return if value.is_a?(Wizrb::Lighting::Group)

          raise Wizrb::Error, "Scenes can only be activated on lighting groups"
        end

        def save_state
          @state_events = @group.map do |device|
            Wizrb::Shared::Events::Base.new(method: "setState", params: device.refresh.state)
          end
        end

        def restore_state
          @group.each_with_index do |device, i|
            device.dispatch_event(@state_events[i])
          end
        end
      end
    end
  end
end
