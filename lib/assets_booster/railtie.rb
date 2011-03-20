require 'rails'
require "assets_booster/packager"
require 'assets_booster/view_helper'

module AssetsBooster
  class Railtie < Rails::Railtie
    cattr_accessor :packager

    config.after_initialize do
      self.packager = AssetsBooster::Packager.new
      ActiveSupport.on_load :action_view do
        ActionView::Base.send(:include, AssetsBooster::ViewHelper)
      end
    end

    rake_tasks do
      load "assets_booster/tasks/tasks.rake"
    end
  end
end

