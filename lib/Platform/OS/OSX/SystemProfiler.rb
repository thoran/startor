# Platform/OS/OSX/SystemProfiler.rb
# Platform::OS::OSX::SystemProfiler

# Description: This uses the built-in system_profiler command on OSX to get access to the version numbers on OSX between 10.4 and 10.9,
# or more generally any version of OSX which has a system_profiler command and which returns results in the same format.

require 'Ordinal/Array'
require 'String/grep'

module Platform
  module OS
    module OSX
      module SystemProfiler

        module_function

        def system_version
          `system_profiler SPSoftwareDataType`.force_encoding('UTF-8').grep(/System Version/).split(': ').second.split.fourth
        end

        def major_system_version
          system_version.split('.').first.to_i
        end

        def minor_system_version
          system_version.split('.').second.to_i
        end

        def tiny_system_version
          system_version.split('.').third.to_i
        end

      end 
    end
  end
end
