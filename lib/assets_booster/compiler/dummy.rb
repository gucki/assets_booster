require 'uri'
require 'net/http'

module AssetsBooster
  module Compiler
    class Dummy
      def self.name
        "Dummy Compiler"
      end
                  
      def self.compile(code)
        code
      end
    end
  end
end

