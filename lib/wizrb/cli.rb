# frozen_string_literal: true

require 'thor'
require_relative 'bulb'

module Wizrb
  class CLI < Thor
    package_name 'Wizrb'

    map '-c' => :connect

    desc 'connect [IP]', 'Connect to a bulb at IP'
    def connect(ip)
      puts "TEST! #{ip}"
    end
  end
end
