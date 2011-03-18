module AssetsBooster
  module Package
    class Javascript < Base
      def self.compiler
        AssetsBooster::Configuration.compiler_for_type(:javascript)
      end
      
      def self.asset_path(name)
        path = AssetsBooster::Configuration.asset_path("javascripts")
        path = File.join(path, name+".js") if name
      end
      
      def view_helper_method
        :javascript_include_tag
      end
    end
  end
end

