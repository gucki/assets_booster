module AssetsBooster
  module Compiler
    class Uglify  
      def name
        'UglifyJS running on Node.js'
      end
          
      def compile(code)
        nodejs = %x[which node].strip
        raise LoadError, "You need to install node.js in order to compile using UglifyJS." unless nodejs.length > 1
        np_path = Pathname.new(File.join(File.dirname(__FILE__), 'node-js')).realpath
        IO.popen("#{nodejs} #{np_path}/uglify.js", "r+") do |io|
          io.write(code)
          io.close_write
          io.read
        end
      end
    end
  end
end

