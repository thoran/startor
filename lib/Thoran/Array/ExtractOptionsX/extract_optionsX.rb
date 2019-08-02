# Thoran/Array/ExtractOptions/extract_optionsX.rb
# Thoran::Array::ExtractOptions#extract_options!

# 20180804
# 0.2.0

# History: Stolen wholesale from ActiveSupport.

# Changes:
# 1. + Thoran namespace.

module Thoran
  module Array
    module ExtractOptionsX

      def extract_options!
        last.is_a?(::Hash) ? pop : {}
      end
      alias_method :extract_options, :extract_options!

   end
 end
end

Array.send(:include, Thoran::Array::ExtractOptionsX)
