require 'compiler/base'
require 'assets_booster/compiler/closure'
module AssetsBooster
  module Compiler
    describe Closure do
      it_behaves_like "a compiler" do
        describe "compile" do
          it "should compile the source file" do
            subject.compile("var a = 'test'; alert(a);").should == 'var a="test";alert(a);'
          end
        end
      end
    end
  end
end

