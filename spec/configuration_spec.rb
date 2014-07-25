require_relative '../lib/southpaw/configuration'

module Southpaw

  describe Configuration do

   # it 'has a logger' do
   #   expect(Configuration.new.logger).to equal STDOUT
   # end

    it 'lets you define methods with a DSL' do
      config = Configuration.new do
        foo bar: 'baz'
      end
      expect(config.foo[:bar]).to eq 'baz'
    end

    it 'removes the method_missing magic after initialization' do
      config = Configuration.new do
        fizz 'buzz'
      end
      expect{ config.asdf }.to raise_error
    end

    it 'raises an error if your config values are nil' do
      expect{
        Configuration.new do
          foo bar: nil
        end
      }.to raise_error(NilConfigValue, "config option foo had {bar => nil}")
    end

  end

end
