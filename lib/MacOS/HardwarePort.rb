# MacOS/HardwarePort.rb
# MacOS::HardwarePort

# 20190829
# 0.3.1

# Changes since 0.2:
# 1. /Hardware/HardwarePort at the top of the file.
# 2. /new()/initialize()/ (Really!? I did that!? Twice!)
# 3. ~ MacOS::HardwarePort.parse, so that it only puts in one entry per hardware port.
# 4. - all()
# 5. + alias_method :all, :parse
# 6. + alias_method :hardware_ports, :parse
# 7. + alias_method :ports, :parse
# 8. + MacOS::HardwarePort.find_by_name
# 9. + MacOS::HardwarePort.find_by_ethernet_address
# 10. + MacOS::HardwarePort#mac_address
# 0/1
# 11. /MacOS::HardwarePort.find_by_device/MacOS::HardwarePort.find_by_interface/
# 11. + alias_method :find_by_device, :find_by_interface
# 12. + MacOS::HardwarePort#interface
# 13. + alias_method :find_by_hardware_port, :find_by_name

require 'Thoran/String/Captures/captures'

module MacOS
  class HardwarePort

    class << self

      def parse(output = nil)
        output ||= self.output
        hardware_ports = []
        hardware_port = nil
        output.each_line do |line|
          # p line
          if line == "\n" || line == ""
            hardware_ports << hardware_port if hardware_port
            hardware_port = new
          else
            label, value = line.captures(/^(.+): (.+)/)
            case label
            when 'Hardware Port'; hardware_port.hardware_port = value
            when 'Device'; hardware_port.device = value
            when 'Ethernet Address'; hardware_port.ethernet_address = value
            end
          end
        end
        hardware_ports
      end
      alias_method :all, :parse
      alias_method :hardware_ports, :parse
      alias_method :ports, :parse

      def find_by_interface(interface)
        all.detect{|hardware_port| hardware_port.interface == interface}
      end
      alias_method :find_by_device, :find_by_interface

      def find_by_name(name)
        all.detect{|hardware_port| hardware_port.name == name}
      end
      alias_method :find_by_hardware_port, :find_by_name

      def find_by_mac_address(mac_address)
        all.detect{|hardware_port| hardware_port.ethernet_address == mac_address}
      end
      alias_method :find_by_ethernet_address, :find_by_mac_address

      private

      def output
        `networksetup -listallhardwareports`
      end

    end # class << self

    attr_accessor :hardware_port
    attr_accessor :device
    attr_accessor :ethernet_address

    def initialize(hardware_port: nil, device: nil, ethernet_address: nil)
      @hardware_port = hardware_port
      @device = device
      @ethernet_address = ethernet_address
    end

    def name
      @hardware_port
    end

    def mac_address
      @ethernet_address
    end

    def interface
      @device
    end

  end
end

if __FILE__ == $0
  require 'pp'
  pp MacOS::HardwarePort.all
  p MacOS::HardwarePort.find_by_device('en4')
  p MacOS::HardwarePort.find_by_name('Wi-Fi')
  p MacOS::HardwarePort.find_by_interface('en4')
end
