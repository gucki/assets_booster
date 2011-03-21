require 'yaml'
module AssetsBooster 
  class Packager
    attr_accessor :config
    attr_accessor :configuration_filename
    attr_accessor :packages

    def self.asset_path(file)
      File.join(Rails.root, "public", file)    
    end

    def initialize(config_filename = nil)
      self.configuration_filename = config_filename || File.join(Rails.root, "config", "assets_booster.yml")
    end
    
    def config
      @config ||= YAML.load_file(configuration_filename)
    end
    
    def packages
      @packages ||= begin
        packages = {}
        config['packages'].each_pair do |type, type_packages|
          type = type.to_sym
          packages[type] = {}
          type_packages.each_pair do |name, assets|
            package = get_package_class(type).new(name, assets)
            package.compiler_class = get_compiler_class_for_type(type)
            packages[type][name] = package
          end
        end
        packages
      end
    end

    def boosted_environment?
      @boosted_environment ||= config['options']['environments'].include?(Rails.env)
    end

    def merge_all
      each_package{ |package| package.merge }
    end

    def compile_all
      each_package{ |package| package.compile }
    end
    
    def delete_all
      each_package{ |package| package.delete }
    end

    def create_configuration
      if File.exists?(configuration_filename)
        AssetsBooster.log("#{configuration_filename} already exists. Aborting task...")
        return
      end
    
      config = {
        'packages' => {
          'javascript' => {
            'base' => file_list("#{Rails.root}/public/javascripts", "js"),
          },
          'stylesheet' => {
            'base' => file_list("#{Rails.root}/public/stylesheets", "css"),
          },
        },
        'options' => {
          'javascript' => {
            'compiler' => "closure",
          },
          'stylesheet' => {
            'compiler' => "yui_css",
          },
          'environments' => %w(staging production),
        }
      }

      File.open(configuration_filename, "w") do |file|
        YAML.dump(config, file)
      end

      AssetsBooster.log("Configuration file #{configuration_filename} created!")
      AssetsBooster.log("Please check the generates packages so dependencies are loaded in correct order.")
    end

    private

    def file_list(path, extension)
      Dir[File.join(path, "*.#{extension}")].map do |file| 
        file[path.length+1..-1].chomp(".#{extension}")
      end
    end
    
    def each_package(&block)
      packages.each_value do |packages|
        packages.each_value do |package|
          block.call(package)
        end
      end
    end

    def get_package_class(type)
      require "assets_booster/package/base"
      require "assets_booster/package/#{type}"
      klass = "AssetsBooster::Package::#{type.to_s.camelize}"
      klass.constantize
    rescue LoadError => e
      raise "You've specified an invalid package type '#{type}'"
    end

    def get_compiler_class(name)
      require "assets_booster/compiler/#{name}"
      klass = "AssetsBooster::Compiler::#{name.to_s.camelize}"
      klass.constantize
    rescue LoadError => e
      raise "You've specified an invalid compiler '#{name}'"
    end

    def get_compiler_class_for_type(type)
      get_compiler_class(config['options'][type.to_s]['compiler'])
    end
  end
end

