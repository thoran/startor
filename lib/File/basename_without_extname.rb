# File#basename_without_extname
# File/basename_without_extname

# 2010.06.05
# 0.0.0

# Description: This returns the basename without the extension for a given File instance without the need to specify what the extension is because it makes use of File.extension which works that out.  

require 'File/extname'

class File
  
  def basename_without_extname
    File.basename(path, extname)
  end
  
end
