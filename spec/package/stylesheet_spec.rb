require 'package/base'
require 'assets_booster/package/stylesheet'
module AssetsBooster
  module Package
    describe Stylesheet do
      it_behaves_like "a package" do
        describe "asset_path" do
          it "should return a stylesheet filename" do
            subject.asset_path("lala").should match(/stylesheets\/lala\.css/) 
          end
        end

        describe "view_helper" do
          before do
            @view = double("View")
          end

          describe "with the inline option enabled" do
            it "should return a style tag with inline css" do
              subject.should_receive(:read).with().and_return("css code")
              @view.should_receive(:style_tag).with("css code")
              subject.view_helper(@view, :inline => true)
            end
          end

          describe "with no options" do
            it "should return html tags" do
              options = {}
              sources = ["source1.css", "source2.css"]
              subject.should_receive(:view_helper_sources).and_return(sources)
              @view.should_receive(:stylesheet_link_tag).with(sources, options)
              subject.view_helper(@view, options)
            end
          end
        end
      end
    end
  end
end

