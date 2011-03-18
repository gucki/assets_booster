module AssetsBooster
  module Compiler
    class Uglify  
      def self.name
        'UglifyJS running on Node.js'
      end
          
      def self.compile(code)
        raise CompileError.new("You need to install node.js in order to compile using UglifyJS.") unless %x[which node].length > 1
        IO.popen("cd #{Pathname.new(File.join(File.dirname(__FILE__),'node-js')).realpath} && node uglify.js", "r+") do |io|
          io.write(code)
          io.close_write
          io.read
        end
      end
    end
  end
end

