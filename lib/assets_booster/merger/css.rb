require 'assets_booster/merger/base'
module AssetsBooster
  module Merger
    class CSS < Base
      def name
        "CSS Merger"
      end
      
      def merge(target)
        target_folder = dirname(target)
        code = assets.inject("") do |code, asset|
          source_folder = dirname(asset[:source])
          asset[:css]= rewrite_urls(asset[:css], source_folder, target_folder)
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
          url, quotes = unquote($1.strip)

          # we don't want to change references to external assets
          next match if absolute_url?(url) 

          "url(#{quotes}#{url_prepend}/#{url}#{quotes})"
        end
      end
      
      def unquote(quoted)
        (quoted[0].chr =~ /["']/) ? [quoted.slice(1, quoted.length-2), quoted[0].chr] : [quoted, ""]
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

