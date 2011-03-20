module AssetsBooster
  module Compiler
    class Rainpress  
      def name
        'Rainpress'
      end

      def compile(css)
        require 'rainpress'
        ::Rainpress.compress(css)
      rescue LoadError => e
        raise LoadError, "To use the Rainpress CSS Compressor, please install the rainpress gem first"
      end
    end
  end
end

