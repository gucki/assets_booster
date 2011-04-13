require 'package/base'
require 'assets_booster/package/javascript'
module AssetsBooster
  module Package
    describe Javascript do
      it_behaves_like "a package" do
        describe "asset_path" do
          it "should return a javascript filename" do
            subject.asset_path("lala").should match(/javascripts\/lala\.js/) 
          end
        end

        describe "view_helper" do
          before do
            @view = double("View")
          end

          describe "with the inline option enabled" do
            it "should return a javascript tag with inline javascript" do
              subject.should_receive(:read).with().and_return("javascript code")
              @view.should_receive(:javascript_tag).with("javascript code")
              subject.view_helper(@view, :inline => true)
            end
          end

          describe "with no options" do
            it "should return html tags" do
              options = {}
              sources = ["source1.js", "source2.js"]
              subject.should_receive(:view_helper_sources).and_return(sources)
              @view.should_receive(:javascript_include_tag).with(sources, options)
              subject.view_helper(@view, options)
            end
          end
        end
      end
    end
  end
end

