module AssetsBooster
  module Mixin
    module Url
      def absolute_url?(url)
        !!(url =~ %r{^/}i)
      end
  
      def external_url?(url)
        !!(url =~ %r{^https?://}i)
      end
      
      def path_difference(source, target)
        return source if target == ""
        if source[0..target.length-1] != target
          raise ArgumentError, "source and target to not share a common base path [#{source}, #{target}]"
        end
        source[target.length+1..-1] || ""
      end
    end
  end
end
