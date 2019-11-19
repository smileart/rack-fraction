# frozen_string_literal: true

# Standard Rack module to implement middleware in the correct namespace
module Rack
  # Middleware which lets you to execute arbitrary code just for a certain fraction of requests
  class Fraction
    # Current lib version
    VERSION = '1.0.0'

    # Initialisation of the middleware
    #
    # @param [Rack::App] app rack app to stack middleware into (passed automatically)
    # @param [Symbol] modify a flag which tells what to modify with this middleware (:response or :env)
    #   anything other than :response would mean :env (default: nil)
    # @param [Integer] percent fraction of the requests that should be affected by this middleware (default: 0)
    # @param [Proc] block the block of code with business logic which modifies response/env
    def initialize(app, modify: nil, percent: 0, &block)
      @app     = app
      @modify  = modify
      @percent = percent.to_i
      @handler = block.respond_to?(:call) ? block : ->(*args) { args }
    end

    # Implementation of the middleware automatically called by Rack
    #
    # @param [Hash] env rack app env automatically passed to the middleware
    #
    # @return [Rack::Response] response after either calling original app and modifying response
    #   or calling the app with modified environment and returning its response
    def call(env)
      if rand(1..100) <= @percent
        if @modify == :response
          # status, headers, body
          response = @handler.call(*@app.call(env))
        else # :env
          modified_env = @handler.call(env) || env
          response = @app.call(modified_env)
        end
      else
        response = @app.call(env)
      end

      response
    end
  end
end
