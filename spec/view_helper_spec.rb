require 'spec_helper'
require 'assets_booster/view_helper'
module AssetsBooster
  describe ViewHelper, :type => :helper do
    describe "style_tag" do
      it "should return a style tag with inline css" do
        pending "don't know how to write view helper specs"
        puts helper.style_tag("body{background:#ff0}")
        helper.style_tag("body{background:#ff0}").should == <<-EOT
          <style type="text/css">
            body{background:#ff0}
          </style>
        EOT
      end
    end

    describe "assets_booster_tag" do
      it "should return html tags" do
        pending "don't know how to write view helper specs"
      end
    end
  end
end

