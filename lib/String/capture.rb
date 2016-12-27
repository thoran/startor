# String/capture
# String#capture

# 20120812
# 0.2.0

# Changes since 0.1: 
# 1. Added some testing.  

class String
  
  def capture(regex)
    if md = self.match(regex)
      md[1]
    else
      nil
    end
  end
  
end
