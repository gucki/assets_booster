require 'spec_helper'
module AssetsBooster
  module Compiler
    shared_examples_for "a compiler" do
      subject{ described_class.new }

      describe "name" do
        it "should return a string" do
          subject.name.should_not be_empty
        end
      end
    end
  end
end

