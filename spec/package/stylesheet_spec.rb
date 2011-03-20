require 'package/base'
require 'assets_booster/package/stylesheet'
module AssetsBooster
  module Package
    describe Stylesheet do
      it_behaves_like "a package" do
        describe "asset_path" do
          it "should return a stylesheet filename" do
            subject.asset_path("lala").should match(/stylesheets\/lala\.css/) 
          end
        end
      end
    end
  end
end

