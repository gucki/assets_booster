require 'assets_booster/merger/base'
module AssetsBooster
  module Merger
    class Simple < Base
      def name
        "Simple Merger"
      end
                  
      def merge(target)
        assets.inject("") do |code, asset|
          code << asset[:css]
          code << "\n"
        end.strip
      end
    end
  end
end

