module AssetsBooster
  module Compiler
    class Dummy
      def name
        "Dummy Compiler"
      end
                  
      def compile(code)
        code
      end
    end
  end
end

