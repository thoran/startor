# Platform/OS/OSX.rb
# Platform::OS::OSX

require 'Files'
require 'Platform/OS/OSX/SystemProfiler'
require 'Thoran/String/Capture/capture'
require 'Version'

module Platform
  module OS
    module OSX

      module_function

      def version
        Version.new(version_string)
      end

      def version_string
        detect(true)
      end

      def name
        detect.split('_').collect{|e| e.capitalize}.join(' ')
      end

      def detect(return_version_string = false)
        if return_version_string
          SystemProfiler.system_version
        else
          self.methods(false).select{|e| e =~ /\?$/}.detect{|e| send(e)}.to_s.capture(/^(\w+)\?/)
        end
      end

      def tiger?
        SystemProfiler.major_system_version == 10 && SystemProfiler.minor_system_version == 4
      end

      def leopard?
        SystemProfiler.major_system_version == 10 && SystemProfiler.minor_system_version == 5
      end

      def snow_leopard?
        SystemProfiler.major_system_version == 10 && SystemProfiler.minor_system_version == 6
      end

      def lion?
        SystemProfiler.major_system_version == 10 && SystemProfiler.minor_system_version == 7
      end

      def mountain_lion?
        SystemProfiler.major_system_version == 10 && SystemProfiler.minor_system_version == 8
      end

      def mavericks?
        SystemProfiler.major_system_version == 10 && SystemProfiler.minor_system_version == 9
      end

      def application_paths(username = nil)
        system_application_paths + user_application_paths(username)
      end

      def system_application_paths
        applications_in_directory('/Applications')
      end

      def user_application_paths(username = nil)
        if username
          applications_in_directory("/Users/#{username}/Applications")
        else
          usernames.collect do |username|
            applications_in_directory("/Users/#{username}/Applications")
          end.flatten
        end
      end

      def usernames
        `dscl . list /users`.split("\n")
          .reject{|username| username =~ /^_/}
            .reject{|username| %w{daemon nobody root}.include?(username)}
      end

      def application_path_for_application(application_name)
        application_paths.detect do |application_path|
          File.basename(application_path) == application_name ||
          File.basename(application_path, '.app') == application_name
        end
      end

      def start(application_name)
        system("open #{application_path_for_application(application_name)}")
      end

      def applications_in_directory(directory)
        Files.new(path: directory, pattern: '*.app').collect{|file| file.path}
      end

    end
  end
end
