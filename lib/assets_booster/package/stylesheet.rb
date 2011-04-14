require 'assets_booster/mixin/css'
module AssetsBooster
  module Package
    class Stylesheet < Base
      include AssetsBooster::Mixin::Css

      def merger_class
        require "assets_booster/merger/css"
        AssetsBooster::Merger::CSS
      end
      
      def asset_path(name)
        path = AssetsBooster::Packager.asset_path("stylesheets")
        path = File.join(path, name+".css") if name
      end
      
      def default_asset_host
        Rails.configuration.action_controller.asset_host
      end

      def view_helper(view, options)
        if options[:inline]
          code = read
          inline = options[:inline]
          if inline.is_a?(Hash)
            if inline[:hostify_urls]
              base_url = (inline[:hostify_urls] == true) ? default_asset_host : inline[:hostify_urls] 
              code = hostify_urls(base_url, code)
            end
          end
          view.style_tag(code, options.except(:inline))
        else
          view.stylesheet_link_tag(view_helper_sources, options)
        end
      end
    end
  end
end

