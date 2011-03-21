module AssetsBooster
  module Compiler
    class YuiCss
      def name
        'YUI Compressor (CSS)'
      end

      def compile(code)
        require "yui/compressor"
        compressor = YUI::CssCompressor.new
        compressor.compress(code)
      rescue LoadError => e
        raise LoadError, "To use the YUI JS/CSS Compressor, please install the yui-compressor gem first"
      end
    end
  end
end

