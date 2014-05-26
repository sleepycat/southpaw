require_relative '../lib/southpaw'

ENV['RACK_ENV'] = 'test'

describe 'The HelloWorld App' do

  let(:env) do
    {'REQUEST_URI' => '/', 'REQUEST_METHOD' => 'GET'}
  end

  def app
    Southpaw.application
  end

  it "says hello" do
    Southpaw.define_routes do
      get '/', {} do
        "Hello World"
      end
    end
    status, headers, response = app.call(env)
    expect(response.body).to eq ['Hello World']
  end
end
