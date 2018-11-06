# String#each_line

# 20120330
# 0.0.0

# Description: Ruby 1.9 no longer mixes in Enumerable, so there's no #each method.  Here's the equivalent 1.8 version of String's missing #each method, but renamed to describe it's functionality more correctly.  See String#each, which calls this method as the default behaviour.  Also see String#each_char.  

class String
  
  def each_line
    lines = self.split("\n")
    0.upto(lines.size - 1){|i| yield lines[i]}
  end
  
end
