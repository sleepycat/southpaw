require 'pry'
require 'rspec'
require_relative '../lib/southpaw/route'

module Southpaw
  describe Route do

    let(:the_block){ Proc.new{}  }
    let(:route){ Route.new(:get, "/foo/{id}", {id: :to_i}, &the_block) }

    it "returns its method" do
      expect(route.method).to eq :get
    end

    it "matches a given URI against its template" do
      expect(route.match("/foo/42")).to eq [{id: 42}, the_block]
    end

    it "returns nil for routes that don't match" do
      expect(route.match('/asdf')).to be_nil
    end

    it "raises an error if you don't provide converters" do
      expect{
        Route.new(:get, 'foo/{id}', {}) {}
      }.to raise_error
    end

    it 'properly handles query parameters' do
      r = Route.new(:get, '/technologies/around{?lat,lng}', {lat: :to_f, lng: :to_f}, &the_block)
      uri = '/technologies/around?lat=45.42&lng=-75.70'
      expect(r.match(uri)).to eq [{:lat=>45.42, :lng=>-75.7}, the_block]
    end
  end
end
