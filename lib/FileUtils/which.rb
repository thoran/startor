# FileUtils#which

# 20100320
# 0.0.0

require 'FileUtils/where'

module FileUtils
  
  def which(executable_sought)
    if where_results = FileUtils.where(executable_sought)
      where_results[0]
    else
      nil
    end
  end
  
  module_function :which
  
end
