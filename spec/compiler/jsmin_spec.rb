require 'compiler/base'
require 'assets_booster/compiler/jsmin'
module AssetsBooster
  module Compiler
    describe JSMin do
      it_behaves_like "a compiler" do
        describe "compile" do
          it "should compile javascript" do
            subject.compile("var a = 'test'; alert(a);").should == "var a='test';alert(a);"
          end
        end
      end
    end
  end
end

