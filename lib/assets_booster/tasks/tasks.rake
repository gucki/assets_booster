require "assets_booster/packager"
namespace :assets_booster do
  desc 'Merge assets'
  task :merge do
    packager = AssetsBooster::Packager.new
    packager.merge_all
  end

  desc 'Merge and compile assets'
  task :compile do
    packager = AssetsBooster::Packager.new
    packager.compile_all
  end

  desc 'Delete all asset builds'
  task :delete do
    packager = AssetsBooster::Packager.new
    packager.delete_all
  end

  desc 'Generate a configuration file for existing assets'
  task :setup do
    packager = AssetsBooster::Packager.new
    packager.create_configuration
  end
end

