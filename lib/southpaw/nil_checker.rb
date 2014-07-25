module Southpaw

  class NilConfigValue < StandardError; end

  module NilChecker

    def raise_exception_for_nil_args method_name, args
        case
        when args.nil?
          raise NilConfigValue, "config option #{method_name} was nil"
        when args.is_a?(Array)
          if args.include? nil
            raise NilConfigValue, "config option #{method_name} had nil value in it"
          end
        when args.is_a?(Hash)
          key_with_nil_value = args.select{|k,v| v.nil? }.keys.first
          unless key_with_nil_value.nil?
            raise NilConfigValue, "config option #{method_name} had {#{key_with_nil_value} => nil}"
          end
        end
    end

  end
end
