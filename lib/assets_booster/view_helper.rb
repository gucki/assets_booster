module AssetsBooster
  module ViewHelper
    def assets_booster_tag(type, *names)
      options = names.extract_options!
      packager = AssetsBooster::Railtie.packager
      packages = packager.packages[type]
      html = names.map do |name|
        methode, sources = packages[name].view_helper(packager)
        send(methode, sources, options)
      end*"\n"
      html.html_safe
    end
  end
end
