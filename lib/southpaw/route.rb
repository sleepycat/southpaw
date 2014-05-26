require 'escape_utils'
require 'uri_template'

module Southpaw
   class Route

     attr_accessor :method, :path, :converters, :block

     def initialize method, path, converters, &block
       @method = method
       @path = URITemplate.new(path)
       unless @path.variables.length == converters.keys.length
         raise "You must have a converter for each expression in the URI"
       end
       @converters = converters
       @block = block
     end

     def match uri
       extracted = @path.extract(uri)
       params = {}
       if extracted
         extracted.each_pair do |key, value|
           params[key.to_sym] = value.send(@converters[key.to_sym])
         end
         [ params, @block ]
       else
         nil
       end
     end

   end
end
