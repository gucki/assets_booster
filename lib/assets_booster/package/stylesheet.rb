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
      
      def view_helper_method
        :stylesheet_link_tag
      end
    end
  end
end

