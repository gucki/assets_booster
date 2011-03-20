require 'merger/base'
require 'assets_booster/merger/css'
module AssetsBooster
  module Merger
    describe CSS do
      it_behaves_like "a merger" do
        describe "merge" do
          subject{ described_class.new(['a.css', 'nested/b.css', 'c.css']) }

          it "should merge sources and rewrite urls" do
            File.stub(:read) do |source| 
              case source
              when 'a.css'
                "{background:url(gucki.png)}"
              when 'nested/b.css'
                "{background:url(gucki.png)}"
              when 'c.css'
                "{background:url(http://www.example.com/gucki.png)}"
              end
            end
            subject.merge("target.css").should == "{background:url(gucki.png)}\n{background:url(nested/gucki.png)}\n{background:url(http://www.example.com/gucki.png)}"
          end

          it "should merge sources and respect import directives" do
            File.stub(:read) do |source| 
              case source
              when 'a.css'
                "@import d.css"
              when 'nested/b.css'
                "@import url(http://www.example.com/test.css)"
              when 'c.css'
                "{color:#fff;}"
              when 'd.css'
                "{color:#f00;}"
              end
            end
            subject.merge("target.css").should == "{color:#f00;}\n\n@import url(http://www.example.com/test.css)\n{color:#fff;}"
          end
        end

        describe "absolute_url?" do
          it "should detect absolute urls" do
            [
              ["http://www.example.com", true],
              ["HTTP://www.example.com", true],
              ["https://www.example.com", true],
              ["/absolute.css", true],
              ["relative.css", false],
              ["another/relative.css", false],
            ].each do |url, result| 
              subject.absolute_url?(url).should == result
            end
          end
        end
        
        describe "path_difference" do
          it "should return the difference" do
            [
              ["", "", ""],
              ["test", "", "test"],
              ["test", "test", ""],
              ["home/test", "", "home/test"],
              ["home/test", "home", "test"],
              ["/home/test", "/home", "test"],
            ].each do |source, target, result| 
              subject.path_difference(source, target).should == result
            end
          end
          it "should raise if source and target dont share a common base path" do
            lambda{ subject.path_difference("/home/gucki/test", "/home/peter") }.should raise_error(ArgumentError)
          end
        end
  
        describe "rewrite_urls" do
          it "should rewrite url properties" do
            subject.rewrite_urls("{color:#f00}", "/home/test", "/home/test").should == "{color:#f00}"
            subject.rewrite_urls("{color:#f00; background:url(test.png)}", "nested", "").should == "{color:#f00; background:url(nested/test.png)}"
            source_folder = "/home/test/nested"
            target_folder = "/home/test"
            [
              [
                "{color:#f00}",
                "{color:#f00}",
              ],
              [
                "{color:#f00; background:url(test.png)}",
                "{color:#f00; background:url(nested/test.png)}",
              ],
              [
                "{color:#f00; background:url(\"test.png\")}",
                "{color:#f00; background:url(\"nested/test.png\")}", 
              ],
              [
                "{color:#f00; background:url('test.png')}",
                "{color:#f00; background:url('nested/test.png')}", 
              ],
              [
                "{color:#f00; background:url('test file.png')}",
                "{color:#f00; background:url('nested/test file.png')}", 
              ],
              [
                "{color:#f00; background:url(../test.png)}",
                "{color:#f00; background:url(nested/../test.png)}", 
              ],
            ].each do |input, output| 
              subject.rewrite_urls(input, source_folder, target_folder).should == output
            end
          end
        end
        
        describe "extract_url" do
          it "should extract urls" do
            [
              ["'test.png'", ["test.png", "'"]],
              ['"test.png"', ["test.png", '"']],
              ["test.png", ["test.png", ""]], 
            ].each do |input, output| 
              subject.extract_url(input).should == output
            end
          end
        end
        
        describe "dirname" do
          it "should return the folder of the given path" do
            [
              ["test.png", ""], 
              ["test/test.png", "test"], 
              ["/test/nested/test.png", "/test/nested"], 
            ].each do |input, output| 
              subject.dirname(input).should == output
            end
          end
        end
      end
    end
  end
end

