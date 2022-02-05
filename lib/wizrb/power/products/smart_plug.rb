# frozen_string_literal: true

require_relative '../../shared/products/device'

module Wizrb
  module Power
    module Products
      class SmartPlug < Wizrb::Shared::Products::Device
        MODULE_NAME_IDENTIFIER = 'SOCKET'

        def initialize(ip:, port: 38_899)
          super
        end
      end
    end
  end
end
