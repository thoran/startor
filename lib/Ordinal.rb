# Ordinal.rb
# Ordinal

# 20140316
# 0.2.0

# Description: This is a collection of methods which relies upon an object having an entries method.

# Notes:
# 1. This was originally meant to be extensions on Enumerable, as can be seen in version 0.0.0, but I decided that any object which provides for an ordered list of entries by way of having an entries method should be able to make use of this.  

# Changes since 0.1:
# 1. - require 'File/self.relative_path' from Ordinal/Array and replaced with require_relative.
# 2. - require 'File/self.relative_path' from Ordinal/Array and replaced with require_relative.

module Ordinal
  
  def first
    entries[0]
  end
  
  def second
    entries[1]
  end
  
  def third
    entries[2]
  end
  
  def fourth
    entries[3]
  end
  
  def fifth
    entries[4]
  end
  
  def sixth
    entries[5]
  end
  
  def seventh
    entries[6]
  end
  
  def eighth
    entries[7]
  end
  
  def ninth
    entries[8]
  end
  
  def tenth
    entries[9]
  end
  
  def eleventh
    entries[10]
  end
  
  def twelfth
    entries[11]
  end
  
  def thirteenth
    entries[12]
  end
  
  def fourteenth
    entries[13]
  end
  
  def fifteenth
    entries[14]
  end
  
  def sixteenth
    entries[15]
  end
  
  def seventeenth
    entries[16]
  end
  
  def eighteenth
    entries[17]
  end
  
  def ninteenth
    entries[18]
  end
  
  def twentieth
    entries[19]
  end
  
  def tenth_last
    entries[count - 10]
  end
  
  def ninth_last
    entries[count - 9]
  end
  
  def eighth_last
    entries[count - 8]
  end
  
  def seventh_last
    entries[count - 7]
  end
  
  def sixth_last
    entries[count - 6]
  end
  
  def fifth_last
    entries[count - 5]
  end
  
  def fourth_last
    entries[count - 4]
  end
  
  def third_last
    entries[count - 3]
  end
  
  def second_last
    entries[count - 2]
  end
  
  def last
    entries[count - 1]
  end
  alias_method :first_last, :last
  
  def all_but_first
    entries.drop(1)
  end
  
  def all_but_last
    entries.take(count - 1)
  end
  
  def all_but_first_and_last
    entries.all_but_first.all_but_last
  end
  
  def first_and_last
    [entries.first] + [entries.last]
  end
  
end
