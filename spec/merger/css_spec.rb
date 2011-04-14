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
                "@import d.css;@import e.css"
              when 'nested/b.css'
                "@import url(http://www.example.com/test.css)"
              when 'c.css'
                "{color:#fff;}"
              when 'd.css'
                "{color:#f00;}"
              when 'e.css'
                "{color:#00f;}"
              end
            end
            subject.merge("target.css").should == "{color:#f00;}\n{color:#00f;}\n\n@import url(http://www.example.com/test.css)\n{color:#fff;}"
          end

          it "should merge sources, combine charset directives and move the remaining one at top" do
            File.stub(:read) do |source| 
              case source
              when 'a.css'
                "{color:#fff;}"
              when 'nested/b.css'
                "@charset 'UTF-8';"
              when 'c.css'
                "@import d.css;@import e.css"
              when 'd.css'
                "{color:#00f;}"
              when 'e.css'
                "@charset 'utf-8'"
              end
            end
            subject.merge("target.css").should == "@charset \"utf-8\";\n{color:#fff;}\n{color:#00f;}\n"
          end

          it "should merge sources, and complain if sources have conflicting charset directives" do
            File.stub(:read) do |source| 
              case source
              when 'a.css'
                "{color:#fff;}"
              when 'nested/b.css'
                "@charset 'UTF-8';"
              when 'c.css'
                "@charset 'iso-8859-1'"
              end
            end
            lambda{ subject.merge("target.css") }.should raise_error(ArgumentError)
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

