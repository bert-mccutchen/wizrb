# frozen_string_literal: true

require 'json'
require 'socket'

module Wizrb
  module Shared
    class Connection
      attr_reader :ip, :port, :connection_id, :socket

      def initialize(ip, port)
        @ip = ip
        @port = port
        @connection_id = Time.now.to_i.to_s(16)
        @socket = UDPSocket.new
        log('Created')
      end

      def connect
        with_error_logging do
          socket.connect(ip, port)
          log('Connected')
        end
      end

      def send(data)
        with_error_logging do
          connect
          log("Sending: #{data.to_json}")
          socket.send(data.to_json.encode('UTF-8'), 0)
        end
      end

      def receive(timeout: 2, max: 1024)
        with_error_logging do
          connect

          ready = socket.wait_readable(timeout)
          raise Wizrb::ConnectionTimeoutError unless ready

          data, _addr = socket.recvfrom(max)
          log("Received: #{data}")
          parse_response(data)
        end
      end

      def test
        with_error_logging do
          send({ method: 'getPilot', params: {} })
          receive
        end
      end

      private

      def parse_response(data)
        response = JSON.parse(data)

        raise Wizrb::ConnectionError, response['error'] if response.key?('error')

        response
      end

      def log(message)
        puts "[Wizrb::Connection##{connection_id} #{ip}:#{port}] #{message}" if ENV['DEBUG']
      end

      def with_error_logging
        yield
      rescue StandardError => e
        log("Error: #{e.message}")
        raise
      end
    end
  end
end
