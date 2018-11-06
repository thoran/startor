# Platform/OS/windowsQ.rb
# Platform::OS#windows?

module Platform
  module OS

    module_function

    def windows?
      mswin32? || mingw32? || cygwin?
    end

    def mswin32?
      RUBY_PLATFORM =~ /mswin32/ ? true : false
    end

    def mingw32?
      RUBY_PLATFORM =~ /mingw32/ ? true : false
    end

    def cygwin?
      RUBY_PLATFORM =~ /cygwin/ ? true : false
    end

  end
end
