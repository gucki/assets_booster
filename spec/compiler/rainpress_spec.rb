require 'compiler/base'
require 'assets_booster/compiler/rainpress'
module AssetsBooster
  module Compiler
    describe Rainpress do
      it_behaves_like "a compiler" do
        describe "compile" do
          it "should compile the source file" do
            subject.compile("{ color: #ff0000; }").should == "{color:red}"
          end
        end
      end
    end
  end
end

