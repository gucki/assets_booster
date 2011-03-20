require 'merger/base'
require 'assets_booster/merger/simple'
module AssetsBooster
  module Merger
    describe Simple do
      it_behaves_like "a merger" do
        describe "merge" do
          subject{ described_class.new(['a', 'b', 'c']) }
          it "should merge source files" do
            File.stub(:read){ |source| source }
            subject.merge("target.css").should == "a\nb\nc"
          end
        end
      end
    end
  end
end

