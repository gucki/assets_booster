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

        describe "default_asset_host" do
          it "should return Rails.configuratrion.action_controller.asset_host" do
            Rails.stub_chain(:configuration, :action_controller, :asset_host).and_return(:test)
            subject.default_asset_host.should == :test
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

            it "should return a style tag with inline css" do
              subject.should_receive(:read).with()
              @view.should_receive(:style_tag).and_return("<style>css</style>")
              subject.view_helper(@view, @options).should == "<style>css</style>"
            end

            it "should not pass the inline option to the tag generator" do
              subject.should_receive(:read).and_return("css code")
              @view.should_receive(:style_tag).with("css code", @options.except(:inline))
              subject.view_helper(@view, @options)
            end
            
            describe "and the hostify_urls option set to true" do
              before do
                @options[:inline] = {:hostify_urls => true}
              end

              it "should return a style tag with inline css whose urls have been hostified with the default asset host" do
                subject.should_receive(:default_asset_host).and_return("http://webcache.eu")
                subject.should_receive(:read).and_return("<style>body{background-image:url(test.png)}</style>")
                @view.should_receive(:style_tag).with("<style>body{background-image:url(http://webcache.eu/test.png)}</style>", @options.except(:inline))
                subject.view_helper(@view, @options)
              end
            end
            
            describe "and the hostify_urls option set to a string" do
              before do
                @options[:inline] = {:hostify_urls => "http://myhost.eu"}
              end

              it "should return a style tag with inline css whose urls have been hostified with the specified host" do
                subject.should_receive(:read).and_return("<style>body{background-image:url(test.png)}</style>")
                @view.should_receive(:style_tag).with("<style>body{background-image:url(http://myhost.eu/test.png)}</style>", @options.except(:inline))
                subject.view_helper(@view, @options)
              end
            end
          end

          describe "with no special options" do
            before do
              @options = {:a => "b"}
            end

            it "should return html tags" do
              sources = ["source1.css", "source2.css"]
              subject.should_receive(:view_helper_sources).and_return(sources)
              @view.should_receive(:stylesheet_link_tag).with(sources, @options)
              subject.view_helper(@view, @options)
            end
          end
        end
      end
    end
  end
end

