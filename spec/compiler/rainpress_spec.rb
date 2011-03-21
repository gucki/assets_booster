require 'compiler/base'
require 'assets_booster/compiler/rainpress'
module AssetsBooster
  module Compiler
    describe Rainpress do
      it_behaves_like "a compiler" do
        describe "compile" do
          it "should compile css" do
            subject.compile("{ color: #ff0000; }").should == "{color:red}"
            pending "rainpress is buggy, see https://github.com/sprsquish/rainpress/issues/1" do
              subject.compile("a.en{background-position:0px 0px}").should == "a.en{background-position:0 0}"
            end
          end
        end
      end
    end
  end
end

