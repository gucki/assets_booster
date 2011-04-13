module AssetsBooster
  module Package
    class Stylesheet < Base
      def merger_class
        require "assets_booster/merger/css"
        AssetsBooster::Merger::CSS
      end
      
      def asset_path(name)
        path = AssetsBooster::Packager.asset_path("stylesheets")
        path = File.join(path, name+".css") if name
      end
      
      def view_helper(view, options)
        if options[:inline]
          view.style_tag(read(assets))
        else
          view.stylesheet_link_tag(view_helper_sources, options)
        end
      end
    end
  end
end

