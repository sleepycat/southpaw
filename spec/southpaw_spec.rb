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

end

module Southpaw

  describe App do

    let(:env) do
      {
        "rack.input"=> StringIO.new(),
        "errors"=>STDERR,
        "REQUEST_METHOD"=>"GET",
        "REQUEST_URI"=>"/foo",
      }
    end

    def get path
      env = {
        "rack.input"=> StringIO.new(),
        "errors"=>STDERR,
        "REQUEST_METHOD"=>"GET",
        "REQUEST_URI"=>path
      }
      app.call(env)
    end

    def app
      Southpaw.application
    end

    it "it returns Rack's famous array of 3 things" do
      Southpaw.define_routes(){ get('/foo', {}, &Proc.new{ "<html>foo</html>" }) }
      expect(Southpaw.application.call(env)).to have_exactly(3).items
    end

    it 'properly deals with query params' do
      Southpaw.define_routes(){ get('/technologies/around{?lat,lng}', {lat: :to_f, lng: :to_f}, &Proc.new {|p| "lat:#{p[:lat]},lng:#{p[:lng]}" }) }
      env['REQUEST_URI'] = '/technologies/around?lat=45.42&lng=-75.70'
      expect(Southpaw.application.call(env)[2].body).to eq ['lat:45.42,lng:-75.7']
    end

    it "responds with a 404 if no routes match" do
      Southpaw.define_routes(){ get('/foo', {}, &Proc.new{}) }
      status, headers, body = get '/bar'
      expect(status).to eq 404
    end



  end

end
