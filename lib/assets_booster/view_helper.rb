module AssetsBooster
  module ViewHelper
    def style_tag(css, options = {})
      content_tag(:style, css, options.merge(:type => Mime::CSS))
    end

    def assets_booster_tag(type, *names)
      options = names.extract_options!
      packages = AssetsBooster::Railtie.packager.packages[type]
      html = names.map do |name|
        packages[name].view_helper(self, options)
      end*"\n"
      html.html_safe
    end
  end
end
