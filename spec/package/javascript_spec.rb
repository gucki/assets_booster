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

          describe "with the inline option" do
            before do
              @options = {:a => "b", :inline => true}
            end

            it "should return a javascript tag with inline javascript" do
              subject.should_receive(:read).with()
              @view.should_receive(:javascript_tag).and_return("<script>javascript</script>")
              subject.view_helper(@view, @options).should == "<script>javascript</script>"
            end

            it "should not pass the inline option to the tag generator" do
              subject.should_receive(:read).and_return("js code")
              @view.should_receive(:javascript_tag).with("js code", @options.except(:inline))
              subject.view_helper(@view, @options)
            end
          end

          describe "with no special options" do
            before do
              @options = {:a => "b"}
            end

            it "should return html tags" do
              sources = ["source1.js", "source2.js"]
              subject.should_receive(:view_helper_sources).and_return(sources)
              @view.should_receive(:javascript_include_tag).with(sources, @options)
              subject.view_helper(@view, @options)
            end
          end
        end
      end
    end
  end
end

