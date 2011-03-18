require "assets_booster/configuration"
require "assets_booster/packager"

namespace :assets_booster do
  desc 'Merge assets'
  task :merge do
    AssetsBooster::Packager.init
    AssetsBooster::Packager.merge_all
  end

  desc 'Merge and compile assets'
  task :compile do
    AssetsBooster::Packager.init
    AssetsBooster::Packager.compile_all
  end

  desc 'Delete all asset builds'
  task :delete do
    AssetsBooster::Packager.init
    AssetsBooster::Packager.delete_all
  end

  desc 'Generate assets_booster.yml from existing assets'
  task :setup do
    AssetsBooster::Packager.init
    AssetsBooster::Configuration.create
  end
end

