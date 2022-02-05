# frozen_string_literal: true

require_relative '../shared/discover'
require_relative 'group'
require_relative 'products/dimable_light'
require_relative 'products/tunable_light'
require_relative 'products/rgb_light'

module Wizrb
  module Lighting
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

        if module_name.include?(Wizrb::Lighting::Products::RgbLight::MODULE_NAME_IDENTIFIER)
          Wizrb::Lighting::Products::RgbLight.new(ip: ip, port: port)
        elsif module_name.include?(Wizrb::Lighting::Products::TunableLight::MODULE_NAME_IDENTIFIER)
          Wizrb::Lighting::Products::TunableLight.new(ip: ip, port: port)
        elsif module_name.include?(Wizrb::Lighting::Products::DimableLight::MODULE_NAME_IDENTIFIER)
          Wizrb::Lighting::Products::DimableLight.new(ip: ip, port: port)
        end
      end

      def group_devices
        Wizrb::Lighting::Group.new(devices: @devices)
      end
    end
  end
end
