# frozen_string_literal: true

require_relative 'event'

module Wizrb
  module Lighting
    module Events
      class RefreshEvent < Wizrb::Lighting::Events::Event
        def initialize
          super(method: 'getPilot')
        end
      end
    end
  end
end
