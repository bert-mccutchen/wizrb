# frozen_string_literal: true

require_relative 'wizrb/version'
require_relative 'wizrb/lighting'
require_relative 'wizrb/lighting/connection'
require_relative 'wizrb/lighting/discover'
require_relative 'wizrb/lighting/group'
require_relative 'wizrb/lighting/state'

Dir["#{File.dirname(__FILE__)}/wizrb/lighting/products/*.rb"].sort.each { |file| require file }
Dir["#{File.dirname(__FILE__)}/wizrb/lighting/events/*.rb"].sort.each { |file| require file }
Dir["#{File.dirname(__FILE__)}/wizrb/lighting/scenes/*.rb"].sort.each { |file| require file }

module Wizrb
  class Error < StandardError; end

  class ConnectionError < Wizrb::Error; end

  class ConnectionTimeoutError < Wizrb::ConnectionError
    def initialize(msg = 'Connection timeout waiting for response.')
      super
    end
  end
end
