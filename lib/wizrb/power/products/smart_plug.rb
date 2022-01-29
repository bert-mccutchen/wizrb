# frozen_string_literal: true

require_relative '../../shared/products/device'

module Wizrb
  module Lighting
    module Products
      class SmartPlug < Wizrb::Shared::Products::Device
        def initialize(ip:, port: 38_899)
          super
        end
      end
    end
  end
end
