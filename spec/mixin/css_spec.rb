require 'assets_booster/mixin/css'
module AssetsBooster
  module Mixin
    describe Css do
      subject do 
        dummy = Class.new
        dummy.extend(described_class)
      end

      describe "adjust_relative_urls" do
        it "should adjust relative urls according to path changes of containing css file" do
          subject.adjust_relative_urls("{color:#f00}", "/home/test", "/home/test").should == "{color:#f00}"
          subject.adjust_relative_urls("{color:#f00; background:url(test.png)}", "nested", "").should == "{color:#f00; background:url(nested/test.png)}"
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
            subject.adjust_relative_urls(input, source_folder, target_folder).should == output
          end
        end

        it "should not change absolute urls" do
          subject.adjust_relative_urls("{color:#f00; background:url(/test.png)}", "nested", "").should == "{color:#f00; background:url(/test.png)}"
        end

        it "should not change external urls" do
          subject.adjust_relative_urls("{color:#f00; background:url(http://external.com/test.png)}", "nested", "").should == "{color:#f00; background:url(http://external.com/test.png)}"
        end
      end

      describe "hostify_urls" do
        it "should transform relative urls into absolute urls using the given base url" do
          subject.hostify_urls("http://webcache.eu", "{color:#f00; background:url(test.png)}").should == "{color:#f00; background:url(http://webcache.eu/test.png)}"
          subject.hostify_urls("http://webcache.eu", "{color:#f00; background:url(/test.png)}").should == "{color:#f00; background:url(http://webcache.eu/test.png)}"
          subject.hostify_urls("http://webcache.eu", "{color:#f00; background:url(nested/test.png)}").should == "{color:#f00; background:url(http://webcache.eu/nested/test.png)}"
        end

        it "should not change externals urls" do
          subject.hostify_urls("http://webcache.eu", "{color:#f00; background:url(http://external.com/test.png)}").should == "{color:#f00; background:url(http://external.com/test.png)}"
        end
      end

      describe "unquote" do
        it "should return unquoted string and quotes" do
          [
            ["'test.png'", ["test.png", "'"]],
            ['"test.png"', ["test.png", '"']],
            ["test.png", ["test.png", ""]], 
          ].each do |input, output| 
            subject.unquote(input).should == output
          end
        end
      end
    end
  end
end

