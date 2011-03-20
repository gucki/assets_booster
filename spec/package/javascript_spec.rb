require 'package/base'
require 'assets_booster/package/javascript'
module AssetsBooster
  module Package
    describe Javascript do
      it_behaves_like "a package" do
        describe "asset_path" do
          it "should return a javascript filename" do
            subject.asset_path("lala").should match(/javascripts\/lala\.js/) 
          end
        end
      end
    end
  end
end

