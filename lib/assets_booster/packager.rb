module AssetsBooster 
  class Packager
    cattr_accessor :packages

    def self.init
      require "assets_booster/configuration"
      Configuration.load
    end

    def self.merge_all
      each_package { |package| package.merge }
    end

    def self.compile_all
      each_package { |package| package.compile }
    end
    
    def self.delete_all
      each_package { |package| package.delete }
    end
    
    private
    
    def self.each_package(&block)
      packages.each_value do |packages|
        packages.each_value do |package|
          block.call(package)
        end
      end
    end
  end
end

