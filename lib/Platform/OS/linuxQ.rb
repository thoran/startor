# Platform/OS/linuxQ.rb
# Platform::OS#linux?

module Platform
  module OS

    module_function

    def linux?
      RUBY_PLATFORM.downcase.include?('linux')
    end
    alias_method :gnu_linux?, :linux?

  end
end
