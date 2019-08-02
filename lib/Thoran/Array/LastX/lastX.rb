# Thoran/Array/LastX/lastX.rb
# Thoran::Array::LastX#last!

# 20180804
# 0.2.3

# Description: Sometimes it makes more sense to treat arrays this way.

# Changes since 0.1:
# 1. Added the complement of the extended version of Array#first!.
# 0/1
# 2. Switched the tests to spec-style.
# 1/2
# 3. Added a test for the state of the array afterward, since this is meant to be an in place change.
# 2/3
# 4. Added tests for the extended functionality introduced in the first version 0.1.0.
# 5. Fixed the implementation, so that the order is retained by unshifting the popped values rather than appending the shifted values as is the case with Array#first!.

module Thoran
  module Array
    module LastX

      def last!(n = 1)
        return_value = []
        n.times{return_value.unshift(self.pop)}
        return_value.size == 1 ? return_value[0] : return_value
      end

    end
  end
end

Array.send(:include, Thoran::Array::LastX)
