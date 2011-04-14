require 'assets_booster/mixin/url'
module AssetsBooster
  module Mixin
    describe Url do
      subject do 
        dummy = Class.new
        dummy.extend(described_class)
      end

      describe "absolute_url?" do
        it "should only detect absolute urls" do
          [
          ["http://www.example.com", false],
            ["HTTP://www.example.com", false],
            ["https://www.example.com", false],
            ["/absolute.css", true],
            ["relative.css", false],
            ["another/relative.css", false],
          ].each do |url, result| 
            subject.absolute_url?(url).should == result
          end
        end
      end

      describe "external_url?" do
        it "should only detect absolute urls" do
          [
            ["http://www.example.com", true],
            ["HTTP://www.example.com", true],
            ["https://www.example.com", true],
            ["/absolute.css", false],
            ["relative.css", false],
            ["another/relative.css", false],
          ].each do |url, result| 
            subject.external_url?(url).should == result
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
    end
  end
end

