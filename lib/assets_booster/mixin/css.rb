require 'assets_booster/mixin/url'
module AssetsBooster
  module Mixin
    module Css
      include Url

      def unquote(quoted)
        (quoted[0].chr =~ /["']/) ? [quoted.slice(1, quoted.length-2), quoted[0].chr] : [quoted, ""]
      end

      def adjust_relative_urls(css, source_folder, target_folder)
        url_prepend = path_difference(source_folder, target_folder)
        return css if url_prepend == ""
  
        css.gsub(/url\(([^)]+)\)/i) do |match|
          url, quotes = unquote($1.strip)

          # we don't want to change references to absolute & external assets
          next match if absolute_url?(url) || external_url?(url) 

          "url(#{quotes}#{url_prepend}/#{url}#{quotes})"
        end
      end

      def hostify_urls(base_url, css)
        css.gsub(/url\(([^)]+)\)/i) do |match|
          url, quotes = unquote($1.strip)

          # we don't want to change references to external assets
          next match if external_url?(url)

          url = url[1..-1] if url[0].chr == "/"
          "url(#{quotes}#{base_url}/#{url}#{quotes})"
        end
      end
    end
  end
end
