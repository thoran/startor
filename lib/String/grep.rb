# String#grep

# 20120330
# 0.1.1

# Changes: 
# 1. + require 'String/each', since Ruby 1.9 no longer mixes in Enumerable.  
# 2. + include Enumerable, since Ruby 1.9 no longer mixes in Enumerable.  
# 0/1
# 3. ~ grep(), so as it joins the lines with linefeeds.  

# Note: 
# 1. It still doesn't do the replace bit yet...  
# 2. There's probably a faster way to do this but for small strings it is plenty good.  

require 'String/each'

class String
  
  include Enumerable
  
  def grep(pattern)
    self.select{|line| line =~ pattern}.join("\n")
  end
  
end
