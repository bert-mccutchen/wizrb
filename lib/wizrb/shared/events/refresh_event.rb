# frozen_string_literal: true

require_relative 'base'

module Wizrb
  module Shared
    module Events
      class RefreshEvent < Wizrb::Shared::Events::Base
        def initialize
          super(method: 'getPilot')
        end
      end
    end
  end
end
