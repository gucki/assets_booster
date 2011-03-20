module AssetsBooster
  module ViewHelper
    def should_merge?
      AssetPackage.merge_environments.include?(Rails.env)
    end

    def assets_booster_tag(type, *names)
      options = names.extract_options!
      packages = AssetsBooster::Packager.packages[type]
      html = names.map do |name|
        methode, sources = packages[name].view_helper
        send(methode, sources, options)
      end*"\n"
      html.html_safe
    end
  end
end
