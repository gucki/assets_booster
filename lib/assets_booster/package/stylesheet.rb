module AssetsBooster
  module Package
    class Stylesheet < Base
      def self.compiler
        AssetsBooster::Configuration.compiler_for_type(:stylesheet)
      end
      
      def self.asset_path(name)
        path = AssetsBooster::Configuration.asset_path("stylesheets")
        path = File.join(path, name+".css") if name
      end
      
      def view_helper_method
        :stylesheet_link_tag
      end
    end
  end
end

