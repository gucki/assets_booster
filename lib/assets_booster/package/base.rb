require "assets_booster/packager"
module AssetsBooster
  module Package
    class Base
      attr_accessor :name
      attr_accessor :assets
      attr_accessor :filename
      attr_accessor :merger_class
      attr_accessor :compiler_class
      
      def initialize(name, assets)
        self.name = name+"_packaged"
        self.assets = assets
        self.filename = asset_path(self.name)
      end

      def exists?
        File.exists?(filename)
      end
      
      def merger
        @merger ||= merger_class.new(sources)
      end
      
      def compiler
        @compiler ||= compiler_class.new
      end

      def mtime
        @mtime ||= merger.mtime 
      end
      
      def sources
        @sources ||= assets.each.map{ |asset| asset_path(asset) }
      end

      def delete
        File.delete(filename) if File.exists?(filename)
      end

      def merge
        AssetsBooster.log("Merging assets using #{merger.name} to #{relative_filename}...")
        save(merger.merge(filename))
      end

      def compile
        merged_code = merge
        AssetsBooster.log("Compiling #{relative_filename} using #{compiler.name}...")
        code = compiler.compile(merged_code)
        AssetsBooster.log("Compilation finished: %5.2f%% saved." % [(1-code.size.to_f/merged_code.size)*100])
        save(code)
      end

      def view_helper_sources
        AssetsBooster::Railtie.packager.boosted_environment? ? [name] : assets
      end

      private
      
      def save(code)
        File.open(filename, "w") do |file|
          file.write(code)
        end
        File.utime(mtime, mtime, filename)
        code
      end

      def read
        File.open(filename, "r") do |file| 
          file.read
        end
      end
      
      def relative_filename
        filename.sub("#{Rails.root}/", "")
      end
    end
  end
end

