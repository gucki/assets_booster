require 'spec_helper'
require 'assets_booster/packager'
module AssetsBooster
  describe Packager do
    before do
      Rails.stub(:root){ "/rails" }
      @messages = []
      AssetsBooster.stub(:log){ |message| @messages << message }
    end

    describe "create_configuration" do
      it "should abort if a configuration file already exists" do
        File.should_receive(:exists?).with(subject.configuration_filename).and_return(true)
        File.should_not_receive(:open).with(subject.configuration_filename, "w")
        subject.create_configuration
        @messages[0].should match(/already exists/)
      end

      it "should create a configration file from current assets" do
        Dir.should_receive(:[]).with("/rails/public/javascripts/*.js").and_return(%w(/rails/public/javascripts/jquery.js /rails/public/javascripts/rails.js))
        Dir.should_receive(:[]).with("/rails/public/stylesheets/*.css").and_return(%w(/rails/public/stylesheets/screen.css))
        File.should_receive(:open).with(subject.configuration_filename, "w").and_yield(nil)
        YAML.should_receive(:dump) do |config, file|
          config['packages']['javascript']['base'].size.should == 2
          config['packages']['stylesheet']['base'].size.should == 1
        end
        subject.create_configuration 
        @messages[0].should match(/created/)
      end
    end
    
    describe "compile_all" do
      it "should compile all assets of all packages" do
        YAML.should_receive(:load_file).with(subject.configuration_filename).and_return(
          'packages' => {
            'javascript' => {
              'base' => %w(jquery rails),
            },
            'stylesheet' => {
              'base' => %w(screen),
            },
          },
          'options' => {
            'javascript' => {
              'compiler' => "uglify",
            },
            'stylesheet' => {
              'compiler' => "rainpress",
            },
            'environments' => %w(test),
          }
        )

        # merging css
        File.should_receive(:read).with("/rails/public/stylesheets/screen.css").once.and_return("html { color: #f00; }")
        file = double("File")
        file.should_receive(:write).with("html { color: #f00; }").once
        File.should_receive(:open).with("/rails/public/stylesheets/base_packaged.css", "w").twice.and_yield(file)
        File.should_receive(:mtime).with("/rails/public/stylesheets/screen.css").once.and_return(13)
        File.should_receive(:utime).with(13, 13, "/rails/public/stylesheets/base_packaged.css").twice

        # compiling css
        file.should_receive(:write).with("html{color:red}").once

        # merging js
        File.should_receive(:read).with("/rails/public/javascripts/jquery.js").once.and_return("var action = 'jquery'; alert('jquery')")
        File.should_receive(:read).with("/rails/public/javascripts/rails.js").once.and_return("action = 4*3; alert('rails')")
        file = double("File")
        file.should_receive(:write).with("var action = 'jquery'; alert('jquery')\naction = 4*3; alert('rails')").once
        File.should_receive(:open).with("/rails/public/javascripts/base_packaged.js", "w").twice.and_yield(file)
        File.should_receive(:mtime).with("/rails/public/javascripts/jquery.js").once.and_return(13)
        File.should_receive(:mtime).with("/rails/public/javascripts/rails.js").once.and_return(14)
        File.should_receive(:utime).with(14, 14, "/rails/public/javascripts/base_packaged.js").twice

        # compiling js
        file.should_receive(:write).with("var action=\"jquery\";alert(\"jquery\"),action=12,alert(\"rails\")").once

        subject.compile_all
        @messages[0].should match(/Merging assets.*CSS Merger/)
        @messages[1].should match(/Compiling.*Rainpress/)
        @messages[3].should match(/Merging assets.*Simple Merger/)
        @messages[4].should match(/Compiling.*UglifyJS/)
      end
    end
  end
end

