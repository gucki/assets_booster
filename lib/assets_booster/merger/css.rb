module AssetsBooster
  module Merger
    class CSS
      cattr_accessor :assets

      def self.name
        "CSS Merger"
      end
                  
      def self.merge(sources, target)
        self.assets = []
        sources.each do |source|
          load_source(source)
        end

        target_folder = File.dirname(target)
        assets.inject("") do |code, asset|
          source_folder = File.dirname(asset[:source])
          rewrite_urls!(asset[:css], source_folder, target_folder)
          code << asset[:css]+"\n"
        end.strip
      end

      def self.mtime(sources)
        self.assets = []
        sources.each do |source|
          load_source(source)
        end
        assets.map{ |asset| File.mtime(asset[:source]) }.max
      end        
      
      private
      
      def self.load_source(source)
        css = File.read(source)
        source_folder = File.dirname(source)
        css.gsub!(/@import\s+([^;\n\s]+)/).each do |import|
          url = $1.gsub(/^url\((.+)\)/i, '\1')
          url, quotes = extract_url(url.strip)

          # we don't want to statically import external stylesheets
          next import if absolute_url?(url)

          # recursively process the imported css
          load_source(source_folder+"/"+url)
          ""
        end
        self.assets << {
          :source => source, 
          :css => css
        }
      end
      
      def self.rewrite_urls!(css, source_folder, target_folder)
        # difference between the source and target location
        url_prepend = source_folder[target_folder.length+1..-1]
        return unless url_prepend 
  
        css.gsub!(/url\(([^)]+)\)/i) do |match|
          url, quotes = extract_url($1.strip)

          # we don't want to change references to external assets
          next match if absolute_url?(url) 

          "url(#{quotes}#{url_prepend}/#{url}#{quotes})"
        end
      end
      
      def self.extract_url(quoted_url)
        (quoted_url[0].chr =~ /["']/) ? [quoted_url.slice(1, quoted_url.length-2), quoted_url[0].chr] : [quoted_url, ""]
      end
      
      def self.absolute_url?(url)
        url[0].chr =~ /^(\/|https?:\/\/)/i
      end
    end
  end
end

