# String#each_char

# 20070101
# 0.0.0

# History: When doing String#any_space? I needed a way to iterate through each character in a string for comparison but not using the ascii representation such as with #each_byte.  

class String
  
  def each_char
    (0..(self.size - 1)).each{|i| yield self[i, 1]}
  end
  
end
