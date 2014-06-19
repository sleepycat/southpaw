require 'rack/test'
require_relative '../lib/southpaw'

ENV['RACK_ENV'] = 'test'

describe 'The HelloWorld App' do

  include Rack::Test::Methods

  def app
    Southpaw.application
  end

  it "says hello" do
    Southpaw.define_routes do
      get '/', {} do
        response.write "Hello World"
      end
    end
    get '/'
    expect(last_response.body).to eq 'Hello World'
  end
end
