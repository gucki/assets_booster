module AssetsBooster
  module Compiler
    class YuiJs
      def name
        'YUI Compressor (JS)'
      end

      def compile(code)
        require "yui/compressor"
        compressor = YUI::JavaScriptCompressor.new
        compressor.compress(code)
      rescue LoadError => e
        raise LoadError, "To use the YUI JS/CSS Compressor, please install the yui-compressor gem first"
      end
    end
  end
end

