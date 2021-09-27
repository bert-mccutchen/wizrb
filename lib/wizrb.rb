# frozen_string_literal: true

require_relative 'wizrb/version'
require_relative 'wizrb/lighting/connection'
require_relative 'wizrb/lighting/discover'
require_relative 'wizrb/lighting/group'
require_relative 'wizrb/lighting/state'

Dir["#{File.dirname(__FILE__)}/wizrb/lighting/products/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/wizrb/lighting/events/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/wizrb/lighting/scenes/*.rb"].each { |file| require file }

module Wizrb
  TYPES = {
    tunable: 'Tunable White',
    dimable: 'Dimmable White',
    rgb: 'RGB Bulb'
  }.freeze

  SCENES = {
    ocean: 1,
    romance: 2,
    sunset: 3,
    party: 4,
    fireplace: 5,
    cozy: 6,
    forest: 7,
    pastel_colors: 8,
    wake_up: 9,
    bedtime: 10,
    warm_white: 11,
    daylight: 12,
    cool_white: 13,
    night_light: 14,
    focus: 15,
    relax: 16,
    true_colors: 17,
    tv_time: 18,
    plantgrowth: 19,
    spring: 20,
    summer: 21,
    fall: 22,
    deepdive: 23,
    jungle: 24,
    mojito: 25,
    club: 26,
    christmas: 27,
    halloween: 28,
    candlelight: 29,
    golden_white: 30,
    pulse: 31,
    steampunk: 32,
    rhythm: 1000
  }.freeze

  class Error < StandardError; end

  class ConnectionError < Wizrb::Error; end

  class ConnectionTimeoutError < Wizrb::ConnectionError
    def initialize(msg = 'Connection timeout waiting for response.')
      super
    end
  end

  class UnknownBulbError < Wizrb::Error; end
end
