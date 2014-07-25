require_relative '../lib/southpaw/nil_checker'

module Southpaw

  describe NilChecker do

    let(:obj) do
      Class.new do
        include NilChecker
      end.new
    end

    describe '#raise_exception_for_nil_args' do

      it 'raise error for a simple nil value' do
        expect{
          obj.raise_exception_for_nil_args :foo, nil
        }.to raise_error(NilConfigValue, "config option foo was nil")
      end

      it 'raise error if one of the keys of a hash is nil' do
        expect{
          obj.raise_exception_for_nil_args(:asdf, foo: nil)
        }.to raise_error(NilConfigValue, 'config option asdf had {foo => nil}')
      end

      it 'raises error if on of the elements of an array is nil' do
        expect{
          obj.raise_exception_for_nil_args(:foo, [1,nil,3])
        }.to raise_error(NilConfigValue, 'config option foo had nil value in it')
      end

    end


  end

end
