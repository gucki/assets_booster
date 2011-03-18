require 'rails'

module AssetsBooster
  class Railtie < Rails::Railtie
    config.after_initialize do
      require "assets_booster/packager"
      AssetsBooster::Packager.init
      ActiveSupport.on_load :action_view do
        require 'assets_booster/view_helper'
        ActionView::Base.send(:include, AssetsBooster::ViewHelper)
      end
    end

    rake_tasks do
      load "assets_booster/tasks/tasks.rake"
    end
  end
end

