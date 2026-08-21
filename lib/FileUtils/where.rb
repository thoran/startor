# FileUtils/where.rb
# FileUtils#where

# 20260609
# 0.1.0

# Changes:
# -/0: Simplify dependencies, especially platform detection.
# 1. - require 'Platform/OS'
# 2. - require 'File/self.basename_without_extname'
# 3. Instead of checking for basename_without_extname if on Windows, instead check for both with and without the extension in a single conditional branch.

module FileUtils
  def where(executable_sought)
    sought_paths = []
    ENV['PATH'].split(File::PATH_SEPARATOR).uniq.each do |path|
      Dir["#{path}/*"].each do |executable|
        basename = File.basename(executable)
        if basename == executable_sought || File.basename(executable, '.*') == executable_sought
          sought_paths << executable
        end
      end
    end
    sought_paths.empty? ? nil : sought_paths
  end

  module_function :where
end
