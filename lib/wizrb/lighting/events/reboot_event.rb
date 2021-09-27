# frozen_string_literal: true

require_relative 'event'

module Wizrb
  module Lighting
    module Events
      class RebootEvent < Wizrb::Lighting::Events::Event
        def initialize
          super(method: 'reboot')
        end
      end
    end
  end
end
