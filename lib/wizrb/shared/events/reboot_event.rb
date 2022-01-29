# frozen_string_literal: true

require_relative 'base'

module Wizrb
  module Shared
    module Events
      class RebootEvent < Wizrb::Shared::Events::Base
        def initialize
          super(method: 'reboot')
        end
      end
    end
  end
end
