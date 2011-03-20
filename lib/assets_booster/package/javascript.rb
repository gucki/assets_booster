module AssetsBooster
  module Package
    class Javascript < Base
      def merger_class
        require "assets_booster/merger/simple"
        AssetsBooster::Merger::Simple
      end
      
      def asset_path(name)
        path = AssetsBooster::Packager.asset_path("javascripts")
        path = File.join(path, name+".js") if name
      end
      
      def view_helper_method
        :javascript_include_tag
      end
    end
  end
end

