# frozen_string_literal: true

require 'ipaddr'
require 'socket'
require 'timeout'
require 'json'
require_relative 'group'
require_relative 'products/dimable_light'
require_relative 'products/tunable_light'
require_relative 'products/rgb_light'

module Wizrb
  module Lighting
    class Discover
      MULTICAST_ADDR = '224.0.0.1'
      BIND_ADDR = '0.0.0.0'
      PORT = 38_899
      REGISTRATION_MESSAGE = {
        method: 'registration',
        params: {
          phoneMac: 'ABCDEFGHIJKL',
          register: false,
          phoneIp: '1.2.3.4',
          id: '1'
        }
      }.to_json

      def initialize(wait: 2)
        @wait = wait
        @listening = false
        @thread = nil
        @lights = []
      end

      def all(filters: {})
        open_socket
        listen_registration(filters)
        dispatch_registration
        sleep(@wait)
        close_registration
        close_socket
        Wizrb::Lighting::Group.new(lights: @lights)
      end

      def home(id)
        all(filters: { 'homeId' => id })
      end

      def room(id)
        all(filters: { 'roomId' => id })
      end

      def self.all(wait: 2, filters: {})
        new(wait: wait).all(filters: filters)
      end

      def self.home(id, wait: 2)
        new(wait: wait).home(id)
      end

      def self.room(id, wait: 2)
        new(wait: wait).room(id)
      end

      private

      def open_socket
        bind_address = IPAddr.new(MULTICAST_ADDR).hton + IPAddr.new(BIND_ADDR).hton

        @socket = UDPSocket.open.tap do |socket|
          socket.setsockopt(:IPPROTO_IP, :IP_ADD_MEMBERSHIP, bind_address)
          socket.setsockopt(:IPPROTO_IP, :IP_MULTICAST_TTL, 1)
          socket.setsockopt(:SOL_SOCKET, :SO_REUSEPORT, 1)
        end
      end

      def listen_registration(filters = {})
        @listening = true

        @socket.bind(BIND_ADDR, PORT)

        @thread = Thread.new do
          while @listening
            data, addr = @socket.recvfrom(65_536)
            light = parse_response(data, addr)
            @lights << light if light && (filters.to_a - light.system_config.to_a).empty?
          end
        end
      end

      def dispatch_registration
        @socket.send(REGISTRATION_MESSAGE, 0, MULTICAST_ADDR, PORT)
      end

      def close_registration
        @listening = false
        @thread.terminate
      end

      def close_socket
        @socket.close
        @socket = nil
      end

      def parse_response(data, addr)
        response = JSON.parse(data)

        resolve_light(ip: addr[2], port: addr[1]) if response.dig('result', 'success') && addr[1] && addr[2]
      rescue StandardError
        nil
      end

      def resolve_light(ip:, port: 38_899)
        module_name = Wizrb::Lighting::Products::Light.new(ip: ip, port: port).module_name

        if module_name.include?('TW')
          Wizrb::Lighting::Products::TunableLight.new(ip: ip, port: port)
        elsif module_name.include?('RGB')
          Wizrb::Lighting::Products::RgbLight.new(ip: ip, port: port)
        else
          Wizrb::Lighting::Products::DimableLight.new(ip: ip, port: port)
        end
      end
    end
  end
end
