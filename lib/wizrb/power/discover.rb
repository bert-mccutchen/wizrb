# frozen_string_literal: true

require_relative '../shared/discover'
require_relative 'group'
require_relative 'products/smart_plug'

module Wizrb
  module Power
    class Discover < Wizrb::Shared::Discover
      private

      def parse_response(data, addr)
        response = JSON.parse(data)
        return unless response.dig('result', 'success') && addr[1] && addr[2]

        resolve_device(ip: addr[2], port: addr[1])
      rescue StandardError
        nil
      end

      def resolve_device(ip:, port: 38_899)
        module_name = Wizrb::Shared::Products::Device.new(ip: ip, port: port).module_name

        if module_name.include?(Wizrb::Power::Products::SmartPlug::MODULE_NAME_IDENTIFIER)
          Wizrb::Power::Products::SmartPlug.new(ip: ip, port: port)
        end

        nil
      end

      def group_devices
        Wizrb::Power::Group.new(devices: @devices)
      end
    end
  end
end
