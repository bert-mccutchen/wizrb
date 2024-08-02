# frozen_string_literal: true

require "json"

module Wizrb
  module Shared
    module Events
      class Base
        attr_reader :params

        def initialize(method:, params: {})
          @method = method
          @params = params
        end

        def to_json(*_args)
          @to_json ||= {method: @method, params: @params}.to_json
        end
      end
    end
  end
end
