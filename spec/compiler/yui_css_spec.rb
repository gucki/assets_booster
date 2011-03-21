require 'compiler/base'
require 'assets_booster/compiler/yui_css'
module AssetsBooster
  module Compiler
    describe YuiCss do
      it_behaves_like "a compiler" do
        describe "compile" do
          it "should compile css" do
            subject.compile("{ color: #ff0000; }").should == "{color:#f00}"
            subject.compile("a.en{background-position:0px 0px}").should == "a.en{background-position:0 0}"
          end
        end
      end
    end
  end
end

