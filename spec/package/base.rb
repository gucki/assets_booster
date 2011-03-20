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
      
      describe "view_helper_method" do
        it "should return a symbol" do
          subject.view_helper_method.should be_an_instance_of(Symbol)
        end
      end
    end
  end
end

