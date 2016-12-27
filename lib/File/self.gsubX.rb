# File/self.gsubX
# File.gsub!

# 20111122
# 0.0.1

# Description: This takes a file and replaces any text it finds according to a regular expression with a supplied string.  

# History: 
# 1. Separated class and instance methods to their own files at File#gsubX 0.3.6/0.4.  

# Changes: 
# 1. /File.gsubX/File\/self.gsubX/.  

class File
  
  def self.gsub!(filename, replacement_pattern, replacement_text, selection_pattern = nil)
    replacement_pattern = (
      case replacement_pattern
      when String; Regexp.new(Regexp.escape(replacement_pattern))
      when Regexp; replacement_pattern
      else; raise
      end
    )
    selection_pattern = replacement_pattern unless selection_pattern
    selection_pattern = (
      case selection_pattern
      when String; Regexp.new(Regexp.escape(selection_pattern))
      when Regexp; selection_pattern
      else; raise
      end
    )
    file_handle = self.open(filename, 'r')
    tmp_file_handle = self.new(filename + '.tmp', 'w')
    modified = false
    file_handle.each do |line|
      if line =~ Regexp.new(selection_pattern)
        tmp_file_handle.print line.gsub(Regexp.new(replacement_pattern), replacement_text)
        modified = true
      else
        tmp_file_handle.print line
      end
    end
    file_handle.close
    tmp_file_handle.close
    if modified
      self.delete(filename)
      self.rename(filename + '.tmp', filename)
    else
      self.delete(filename + '.tmp')
    end
  end
  
end
