module AssetsBooster
  module ViewHelper
    def style_tag(content_or_options_with_block = nil, html_options = {}, &block)
      content =
        if block_given?
          html_options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
          capture(&block)
        else
          content_or_options_with_block
        end
    
      content_tag(:style, style_cdata_section(content), html_options.merge(:type => Mime::CSS))
    end

    def style_cdata_section(content)
      "\n/*#{cdata_section("*/\n#{content}\n/*")}*/\n".html_safe
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
