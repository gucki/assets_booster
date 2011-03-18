require 'assets_booster/railtie' if defined?(Rails)

module AssetsBooster
  def self.log(message)
    puts message
  end
end
