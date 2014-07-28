require 'pry'
require 'rack/test'
require 'rspec'
require_relative '../lib/southpaw'

describe Southpaw do


  it "allows you to define routes" do
    Southpaw.define_routes(){ get('/foo', {}, &Proc.new{}) }
    expect(Southpaw.routes[:get].length).to eq 1
  end


  [:get, :put, :post, :delete, :patch, :head].each do |http_method|
    it "provides the #{http_method} method for adding a route" do
      Southpaw.define_routes(){ send(http_method, '/foo/{id}', {id: :to_s}, &Proc.new{}) }
      expect(Southpaw.routes[http_method].length).to eq 1
    end
  end

  it "returns an app with the defined routes" do
    Southpaw.define_routes(){ get('/foo', {}, &Proc.new{}) }
    app = Southpaw.application
    expect(app.routes[:get].length).to eq 1
  end

  it 'allows you to configure it' do
    Southpaw.configuration do
      foo bar: 'baz'
    end
    expect(Southpaw.application.config.foo[:bar]).to eq 'baz'
  end

end

module Southpaw

  describe App do

    include Rack::Test::Methods

    def app
      Southpaw.application
    end

    it 'properly deals with query params', focus: true do
      Southpaw.define_routes do
        get '/technologies/around{?lat,lng}', {lat: :to_f, lng: :to_f} do |p|
          response.write "lat:#{p[:lat]},lng:#{p[:lng]}"
        end
      end
      get '/technologies/around?lat=45.42&lng=-75.70'
      expect(last_response.body).to eq 'lat:45.42,lng:-75.7'
    end

    it "responds with a 404 if no routes match" do
      Southpaw.define_routes(){ get('/foo', {}, &Proc.new{}) }
      get '/bar'
      expect(last_response.status).to eq 404
    end

    it "responds with a 500 when things explode" do
      Southpaw.define_routes(){ get('/foo', {}, &Proc.new{|p| raise 'hell' }) }
      get '/foo'
      expect(last_response.status).to eq 500
    end

    it 'writes errors to rack.errors' do
      err = double('stderr', flush: true)
      expect(err).to receive(:puts).with(/RuntimeError/)
      Southpaw.define_routes(){ get('/foo', {}, &Proc.new{|p| raise 'hell' }) }
      get '/foo', {}, {'rack.errors' => err }
    end

    it 'gives access to a response object within the block' do
      Southpaw.define_routes(){ get('/foo', {}, &Proc.new{|p| response.write 'foo!' }) }
      get '/foo'
      expect(last_response.body).to eq 'foo!'
    end

  end

end
