require 'uri'
require 'net/http'

module AssetsBooster
  module Compiler
    class Closure
      def self.name
        "Google Closure Compiler"
      end
                  
      def self.compile(code)
        post_data = {
          'js_code'=> code,
          'compilation_level' => 'SIMPLE_OPTIMIZATIONS',
          'output_format' => 'text',
          'output_info' => 'compiled_code'
        }
        uri = URI.parse('http://closure-compiler.appspot.com/compile')      
        res = Net::HTTP.post_form(uri, post_data)
        case res
        when Net::HTTPSuccess
          data = res.body.strip
          if code.size > 0 && data.size < 1
            post_data['output_info'] = 'errors'
            res = Net::HTTP.post_form(uri, post_data)
            raise CompileError.new("Google's Closure Compiler failed: "+res.body)
          end
          data
        else
          raise CompileError.new("HTTP request TO Google's Closure Compiler failed: "+res.to_s)
        end     
      end
    end
  end
end

