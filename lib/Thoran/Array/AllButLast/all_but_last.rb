# Thoran/Array/AllButLast/all_but_last.rb
# Thoran::Array::AllButLast#all_but_last

# 20180804
# 0.1.0

# Description: This returns a copy of the receiving array with the last element removed.  

# Changes:
# 1. + Thoran namespace.

require 'Thoran/Array/LastX/lastX'

module Thoran
  module Array
    module AllButLast

      def all_but_last
        d = self.dup
        d.last!
        d
      end

    end
  end
end

Array.send(:include, Thoran::Array::AllButLast)
