# OSX/IfConfig.rb
# OSX::IfConfig

# 20180209
# 0.2.0

# Changes since 0.1:
# 1. + OSX namespace, under the assumption that the output of ifconfig on OSX is different from other operating systems.
require 'Thoran/String/Captures/captures'

module OSX
  class IfConfig

    def new(output = nil)
      @output = output
    end

    def interfaces
      parse.keys
    end

    def active_interfaces
      parse.select do |interface, details|
        details.any?{|detail| detail =~ /status: active/}
      end.keys
    end

    private

    def output
      @output || `ifconfig -a`
    end

    def parse
      interfaces = {}
      interface = nil
      output.each_line do |line|
        if line =~ /^\t/
          interfaces[interface] << line.sub(/^\t/, '')
        else
          interface, rest_of_line = line.captures(/^(.+?): (.+)$/)
          interfaces[interface] = [rest_of_line]
        end
      end
      interfaces
    end

  end
end

if __FILE__ == $0
  require 'pp'
  ic = OSX::IfConfig.new
  pp ic.send(:parse)
  ic.interfaces
  ic.active_interfaces
end
