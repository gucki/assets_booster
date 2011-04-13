require 'spec_helper'
require 'assets_booster/package/base'
module AssetsBooster
  module Package
    shared_examples_for "a package" do
      subject{ described_class.new("test", []) }
      
      before do
        Rails.stub(:root){ "/rails" }
      end
      
      describe "name" do
        it "should return a string" do
          subject.name.should_not be_empty
        end
      end
      
      describe "view_helper_sources" do
        before do
          AssetsBooster::Railtie.packager = double("Packager")
        end
        
        it "should return a the package if running in a boosted environment" do
          AssetsBooster::Railtie.packager.should_receive(:boosted_environment?).and_return(true)
          subject.view_helper_sources.should == [subject.name]
        end

        it "should return the package's sources if running in a non-boosted environment" do
          AssetsBooster::Railtie.packager.should_receive(:boosted_environment?).and_return(false)
          subject.view_helper_sources.should == subject.assets
        end
      end
    end
  end
end

