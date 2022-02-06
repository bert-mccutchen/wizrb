# frozen_string_literal: true

require 'ipaddr'
require 'socket'
require 'json'
require_relative 'group'
require_relative 'products/device'

module Wizrb
  module Shared
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
        @devices = []
      end

      def all(filters: {})
        open_socket
        listen_registration(filters)
        dispatch_registration
        sleep(@wait)
        close_registration
        close_socket
        group_devices
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
            device = parse_response(data, addr)
            @devices << device if device && (filters.to_a - device.system_config.to_a).empty?
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
        return unless response.dig('result', 'success') && addr[1] && addr[2]

        Wizrb::Shared::Products::Device.new(ip: addr[2], port: addr[1])
      rescue StandardError
        nil
      end

      def group_devices
        Wizrb::Shared::Group.new(devices: @devices)
      end
    end
  end
end
