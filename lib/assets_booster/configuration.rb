require 'yaml'
module AssetsBooster
  class Configuration
    cattr_accessor :filename
    cattr_accessor :config
    
    self.filename = File.join(Rails.root, "config", "assets_booster.yml")
    
    def self.load
      self.config = YAML.load_file(filename)
      AssetsBooster::Packager.packages = {}
      config['packages'].each_pair do |type, packages|
        type = type.to_sym
        AssetsBooster::Packager.packages[type] = {}
        packages.each_pair do |name, assets|
          AssetsBooster::Packager.packages[type][name] = get_package(type).new(name, assets)
        end
      end
    end

    def self.asset_path(file)
      File.join(Rails.root, "public", file)    
    end

    def self.compiler_for_type(type)
      get_compiler(config['options'][type.to_s]['compiler'])
    end
    
    def self.defaults
      {
        'packages' => {
          'javascript' => {},
          'stylesheet' => {},
        },
        'options' => {
          'compiler' => {
            'javascript' => {
              'name' => "closure",
              'options' => "",
            },
            'stylesheet' => {
              'name' => "dummy",
              'options' => "",
            }
          },
          'environments' => %w(staging production),
        }
      }
    end

    def self.create
      if File.exists?(filename)
        AssetsBooster.log "#{filename} already exists. Aborting task..."
        return
      end
    
      config = defaults
      config['packages']['javascript'] = {
        "base" => file_list("#{Rails.root}/public/javascripts", "js"),
      }
      config['packages']['stylesheet'] = {
        "base" => file_list("#{Rails.root}/public/stylesheets", "css"),
      }

      File.open(filename, "w") do |out|
        YAML.dump(config, out)
      end
      self.config = config

      AssetsBooster.log("#{filename} example file created!")
      AssetsBooster.log("Please reorder files under 'base' so dependencies are loaded in correct order.")
    end
    
    def self.boosted_environment?
      @boosted_environment ||= config['options']['environments'].include?(Rails.env)
    end

    private

    def self.file_list(path, extension)
      Dir[File.join(path, "*.#{extesnsion}")].map do |file| 
        file.chomp(".#{extension}")
      end
    end    

    def self.get_package(type)
      require "assets_booster/package/base"
      require "assets_booster/package/#{type}"
      klass = "AssetsBooster::Package::#{type.to_s.camelize}"
      klass.constantize
    rescue LoadError => e
      raise "You've specified an invalid package type '#{type}'"
    end

    def self.get_compiler(name)
      require "assets_booster/compiler/#{name}"
      klass = "AssetsBooster::Compiler::#{name.to_s.camelize}"
      klass.constantize
    rescue LoadError => e
      raise "You've specified an invalid compiler '#{name}'"
    end
  end
end

