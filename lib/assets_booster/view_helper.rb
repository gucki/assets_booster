module AssetsBooster
  module ViewHelper
    def should_merge?
      AssetPackage.merge_environments.include?(Rails.env)
    end

    def assets_booster_package(type, *names)
      options = names.extract_options!
      html = names.map do |name|
        methode, sources = AssetsBooster::Packager.packages[type][name].view_helper
        send(methode, sources, options)
      end*"\n"
      html.html_safe
    end
  end
end
