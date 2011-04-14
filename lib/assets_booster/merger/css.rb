require 'assets_booster/mixin/css'
require 'assets_booster/merger/base'
module AssetsBooster
  module Merger
    class CSS < Base
      include AssetsBooster::Mixin::Css

      def name
        "CSS Merger"
      end
      
      def merge(target)
        target_folder = dirname(target)
        code = assets.inject("") do |code, asset|
          source_folder = dirname(asset[:source])
          asset[:css]= adjust_relative_urls(asset[:css], source_folder, target_folder)
          code << asset[:css]
          code << "\n"
        end.strip
        
        charset = nil
        code.gsub!(/@charset\s+([^;\n]+)[;\n]*/).each do
          current_charset, quotes = unquote($1)
          current_charset.downcase!
          if charset && charset != current_charset
            raise ArgumentError, "source files have conflicting charsets (#{charset} != #{current_charset})"
          end
          charset = current_charset
          ""
        end
        
        if charset
          code = "@charset \"#{charset}\";\n"+code
        end

        code
      end

      def load_source(source)
        super(source)
        asset = assets.pop
        source_folder = dirname(asset[:source])
        source_folder << "/" unless source_folder == ""
        asset[:css].gsub!(/@import\s+([^;\n]+)[;\n]*/).each do |import|
          url = $1.gsub(/^url\((.+)\)/i, '\1')
          url, quotes = unquote(url.strip)
          
          # we don't want to statically import external stylesheets
          next import if external_url?(url)

          # recursively process the imported css
          load_source(source_folder+url)
          ""
        end
        assets << asset
      end
  
      def dirname(path)
        path.include?("/") ? File.dirname(path) : ""
      end
    end
  end
end

