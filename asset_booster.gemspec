# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "assets_booster/version"

Gem::Specification.new do |s|
  s.name        = "assets_booster"
  s.version     = AssetsBooster::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Corin Langosch"]
  s.email       = ["info@netskin.com"]
  s.homepage    = "http://github.com/gucki/assets_booster"
  s.summary     = %q{Assets (javascripts, css) compression for rails applications}
  s.description = %q{Instead of sending down a dozen JavaScript and CSS files full of formatting and comments, this gem makes it simple to merge and compress these into one or more files, increasing speed and saving bandwidth.}

  s.rubyforge_project = "assets_booster"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~>3.0.5"
  s.add_dependency "rainpress", "~>1.0"
  s.add_dependency "yui-compressor", "~>0.9.4"
  s.add_dependency "yui-compressor", ">=0.9.6"

  s.add_development_dependency "rspec", "~>2.5.0"
  s.add_development_dependency "rspec-rails", "~>2.5.0"
end
