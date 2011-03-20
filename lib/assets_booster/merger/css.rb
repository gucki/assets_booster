require 'assets_booster/merger/base'
module AssetsBooster
  module Merger
    class CSS < Base
      def name
        "CSS Merger"
      end
      
      def merge(target)
        target_folder = dirname(target)
        assets.inject("") do |code, asset|
          source_folder = dirname(asset[:source])
          asset[:css]= rewrite_urls(asset[:css], source_folder, target_folder)
          code << asset[:css]
          code << "\n"
        end.strip
      end

      def load_source(source)
        super(source)
        asset = assets.pop
        source_folder = dirname(asset[:source])
        source_folder << "/" unless source_folder == ""
        asset[:css].gsub!(/@import\s+([^;\n\s]+)/).each do |import|
          url = $1.gsub(/^url\((.+)\)/i, '\1')
          url, quotes = extract_url(url.strip)

          # we don't want to statically import external stylesheets
          next import if absolute_url?(url)

          # recursively process the imported css
          load_source(source_folder+url)
          ""
        end
        assets << asset
      end

      def rewrite_urls(css, source_folder, target_folder)
        url_prepend = path_difference(source_folder, target_folder)
        return css if url_prepend == ""
  
        css.gsub(/url\(([^)]+)\)/i) do |match|
          url, quotes = extract_url($1.strip)

          # we don't want to change references to external assets
          next match if absolute_url?(url) 

          "url(#{quotes}#{url_prepend}/#{url}#{quotes})"
        end
      end
      
      def extract_url(quoted_url)
        (quoted_url[0].chr =~ /["']/) ? [quoted_url.slice(1, quoted_url.length-2), quoted_url[0].chr] : [quoted_url, ""]
      end
      
      def absolute_url?(url)
        !!(url =~ /^(\/|https?:\/\/)/i)
      end
      
      def dirname(path)
        path.include?("/") ? File.dirname(path) : ""
      end
      
      def path_difference(source, target)
        return source if target == ""
        if source[0..target.length-1] != target
          raise ArgumentError, "source and target to not share a common base path [#{source}, #{target}]"
        end
        source[target.length+1..-1] || ""
      end
    end
  end
end

