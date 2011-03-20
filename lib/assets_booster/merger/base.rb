module AssetsBooster
  module Merger
    class Base
      attr_accessor :assets

      def initialize(sources)
        self.assets = []
        sources.each do |source|
          load_source(source)
        end
      end

      def mtime
        assets.map{ |asset| File.mtime(asset[:source]) }.max
      end        

      def load_source(source)
        assets << {
          :source => source, 
          :css => File.read(source),
        }
      end
    end
  end
end

