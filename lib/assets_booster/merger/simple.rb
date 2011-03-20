require 'uri'
require 'net/http'

module AssetsBooster
  module Merger
    class Simple
      def self.name
        "Simple Merger"
      end
                  
      def self.merge(sources, target)
        sources.inject("") do |code, source|
          File.open(source, "r") do |file|
            code << file.read.strip+"\n"
          end
        end.strip
      end
    end
  end
end

