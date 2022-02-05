# frozen_string_literal: true

require_relative 'base'

module Wizrb
  module Shared
    module Events
      class ResetEvent < Wizrb::Shared::Events::Base
        def initialize
          super(method: 'reset')
        end
      end
    end
  end
end
