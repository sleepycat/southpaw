require_relative './nil_checker'

module Southpaw

  class Configuration

    include Southpaw::NilChecker

    def initialize
      define_method_missing
      instance_eval &Proc.new
      undefine_method_missing
    end

    private

    def define_method_missing
      eigenclass.__send__ :define_method, :method_missing do |meth, *args|
        raise_exception_for_nil_args meth.to_sym, args[0]
        eigenclass.send :attr_reader, meth.to_sym
        instance_variable_set "@#{meth}".to_sym, args[0]
      end
    end

    def undefine_method_missing
      eigenclass.__send__ :undef_method, :method_missing
    end


    def eigenclass
      class << self
        self
      end
    end

  end
end

