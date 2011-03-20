require 'spec_helper'
require 'assets_booster/merger/base'
module AssetsBooster
  module Merger
    shared_examples_for "a merger" do
      subject{ described_class.new([]) }

      describe "name" do
        it "should return a string" do
          subject.name.should_not be_empty
        end
      end

      describe "mtime" do
        subject{ described_class.new(['a', 'b', 'c']) }
        it "should return the last modification time of all sources" do
          File.stub(:read){ "" }
          File.stub(:mtime) do |asset|
            case asset
            when 'a' then 1
            when 'b' then 3
            when 'c' then 2
            end
          end
          subject.mtime.should == 3
        end
      end
    end
  end
end

