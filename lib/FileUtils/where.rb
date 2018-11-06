# FileUtils/where.rb
# FileUtils#where

# 20140912
# 0.0.2

# History: Derived from where 0.2.3---the original command version I wrote in Ruby.

# Changes:
# 1. Removed trailing spaces.
# 2. - require 'File/extension', since it doesn't seem to be being used.
# 3. /require 'File/basename_without_extension'/require 'File/basename_without_extname'/, and uses thereof.
# 4. /require 'Platform/windowsQ'/require 'Platform/OS', and use thereof.

require 'File/basename_without_extname'
require 'Platform/OS'

module FileUtils

  def where(executable_sought)
    paths = ENV['PATH'].split(/:/)
    sought_paths = []
    paths.uniq.each do |path|
      Dir["#{path}/*"].each do |executable|
        if Platform::OS.windows?
          sought_paths << executable if File.basename_without_extname(executable) == File.basename_without_extname(executable_sought)
        else
          sought_paths << executable if File.basename(executable) == executable_sought
        end
      end
    end
    sought_paths.empty? ? nil : sought_paths
  end

  module_function :where

end
