require 'compiler/base'
require 'assets_booster/compiler/yui_js'
module AssetsBooster
  module Compiler
    describe YuiJs do
      it_behaves_like "a compiler" do
        describe "compile" do
          it "should compile javscript" do
            subject.compile("var a = 'test'; alert(a);").should == 'var a="test";alert(a);'
          end
        end
      end
    end
  end
end

