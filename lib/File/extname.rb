# File/extname.rb
# File#extname

# 20140412
# 0.2.0

# Description: This is the instance method version of the class method on File by the same name.

# Changes since 0.1:
# 1. Using the built-in class-method now.

class File

  def extname
    File.extname(path)
  end

end
