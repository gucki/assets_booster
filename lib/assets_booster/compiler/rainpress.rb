module AssetsBooster
  module Compiler
    class Rainpress  
      def self.name
        'Rainpress'
      end

      def self.compile(css)
        require 'rainpress'
        ::Rainpress.compress(css)
      rescue LoadError => e
        raise "To use the Rainpress CSS Compressor, please install the rainpress gem first"
      end
    end
  end
end

