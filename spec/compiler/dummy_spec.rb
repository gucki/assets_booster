require 'compiler/base'
require 'assets_booster/compiler/dummy'
module AssetsBooster
  module Compiler
    describe Dummy do
      it_behaves_like "a compiler" do
        describe "compile" do
          it "should do nothing" do
            subject.compile("var a = 'test'; alert(a);").should == "var a = 'test'; alert(a);"
          end
        end
      end
    end
  end
end

