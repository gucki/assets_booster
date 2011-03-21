require 'compiler/base'
require 'assets_booster/compiler/uglify'
module AssetsBooster
  module Compiler
    describe Uglify do
      it_behaves_like "a compiler" do
        describe "compile" do
          it "should compile javascript" do
            subject.compile("var a = 'test'; alert(a);").should == 'var a="test";alert(a)'
          end
        end
      end
    end
  end
end

