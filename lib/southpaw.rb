require 'rack'
require_relative 'southpaw/route'
require_relative "southpaw/version"

module Southpaw

  class << self

    # Class methods
    attr_reader :routes

    [:get, :put, :post, :delete, :patch, :head].each do |http_method|
      define_method http_method do |path, converters, &block|
        save_route(http_method, path, converters, &block)
      end
    end

    def define_routes
      @routes = { get: [], put: [], post: [], delete: [], patch: [], head: [] }
      class_eval &Proc.new
    end

    def application
      App.new.tap do |app|
        app.routes = @routes
      end
    end

    private

    def save_route method, path, converters, &block
      @routes[method.downcase.to_sym] << Route.new(method, path, converters, &block)
    end


  end

  class App

    attr_accessor :routes, :request, :response

    def call env
      @request = Rack::Request.new env
      @response = Rack::Response.new
      @routes[request.request_method.downcase.to_sym].each do |route|
        @params, @block = route.match(request.fullpath)
        break unless @block.nil?
      end
      if @block
        begin
          instance_exec(@params, &@block)
        rescue StandardError => e
          response.status = 500
          response.write("Internal Server error. Sorry.")
        end
      else
        response.status = 404
        response.write("Page not found")
      end
      response.finish
    end
  end



end
