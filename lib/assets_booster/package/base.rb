module AssetsBooster
  module Package
    class Base
      attr_accessor :name
      attr_accessor :filename
      attr_accessor :assets
      
      def initialize(name, assets)
        self.name = name+"_packaged"
        self.assets = assets
        self.filename = self.class.asset_path(self.name)
      end

      def exists?
        File.exists?(filename)
      end

      def delete
        File.delete(filename) if File.exists?(filename)
      end

      def merge
        AssetsBooster.log("Merging assets to #{relative_filename}...")
        code = ""
        assets.each do |asset|
          File.open(self.class.asset_path(asset), "r") do |src|
            code << src.read+"\n"
          end
        end
        File.open(filename, "w") do |file|
          file.write(code)
        end
      end
      
      def compile
        merge
        merged = read
        AssetsBooster.log("Compiling #{relative_filename} using #{self.class.compiler.name}...")
        code = self.class.compiler.compile(merged)
        File.open(filename, "w") do |file|
          file.write(code)
        end
        AssetsBooster.log("Compilation finished: %5.2f%% saved."%[(1-code.size.to_f/merged.size)*100])
      end

      def view_helper
        sources = AssetsBooster::Configuration.boosted_environment? ? [name] : assets
        [view_helper_method, sources]
      end

      private
      
      def read
        File.open(filename, "r") do |file| 
          file.read
        end
      end
      
      def relative_filename
        filename.sub(Rails.root, ".")
      end
    end
  end
end

