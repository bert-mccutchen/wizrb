# frozen_string_literal: true

require 'json'
require 'socket'
require 'timeout'

module Wizrb
  module Lighting
    class Connection
      def initialize(ip, port)
        @ip = ip
        @port = port
        @connection_id = Time.now.to_i.to_s(16)
        @socket = UDPSocket.new
        log('Created')
      end

      def connect
        @socket.connect(@ip, @port)
        log('Connected')
      rescue StandardError
        log('Error!')
        raise Wizrb::ConnectionError, 'Failed to connect to device'
      end

      def send(data)
        connect
        log("Sending: #{data.to_json}")
        @socket.send(data.to_json.encode('UTF-8'), 0)
      rescue StandardError
        log('Error!')
        raise Wizrb::ConnectionError, 'Failed to send data to device'
      end

      def recieve(timeout: 2, max: 1024)
        connect

        Timeout.timeout(timeout, Wizrb::ConnectionTimeoutError) do
          data, _addr = @socket.recvfrom(max)
          log("Recieved: #{data}")

          response = JSON.parse(data)
          raise Wizrb::ConnectionError, response['error'] if response.key?('error')

          response
        end
      rescue Wizrb::ConnectionTimeoutError
        log('Timeout!')
        raise
      rescue Wizrb::ConnectionError
        log('Error!')
        raise
      rescue StandardError
        log('Error!')
        raise Wizrb::ConnectionError, 'Failed to recieve data from device'
      end

      def test
        send({ method: 'getPilot', params: {} })
        recieve
      rescue StandardError
        log('Error!')
        raise Wizrb::ConnectionError, 'Failed to test device connection'
      end

      private

      def log(message)
        puts "[Wizrb::Connection##{@connection_id} #{@ip}:#{@port}] #{message}" if ENV['DEBUG']
      end
    end
  end
end
