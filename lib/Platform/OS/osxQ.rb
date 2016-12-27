# Platform/OS/osxQ.rb
# Platform::OS#osx?

module Platform
  module OS

    module_function

    def osx?
      RUBY_PLATFORM.downcase.include?('darwin')
    end
    alias_method :darwin?, :osx?

  end
end
