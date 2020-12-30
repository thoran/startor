# MacOS/IfConfig.rb
# MacOS::IfConfig

# 20200429
# 0.6.0

# Changes since 0.5:
# 1. + MacOS::Ifconfig.find_by_interface
# 2. + MacOS::Ifconfig.find_by_mac_address
# 3. + MacOS::Ifconfig.find_by_ipv4_address

require 'Thoran/String/Capture/capture'
require 'Thoran/String/Captures/captures'

module MacOS
  class IfConfig

    class << self

      def parse(output = nil)
        output ||= self.output
        @ifconfigs = []
        interface = nil
        output.each_line do |line|
          if line =~ /^\t/
            case line
            when /ether/
              @ifconfig.mac_address = line.capture(/ *ether (.+) $/)
            when /inet /
              if line.match(/broadcast/)
                @ifconfig.ipv4_address, @ifconfig.netmask, @ifconfig.broadcast_address = line.captures(/ *inet (\d+(?:\.\d+){3}) netmask (.+) broadcast (.+)$/)
              elsif line.match(/-->/)
                ipv4_addresses, @ifconfig.netmask = line.captures(/ *inet (.+) netmask (.+) $/)
                @ifconfig.ipv4_address = ipv4_addresses.split(' --> ').first
              else
                @ifconfig.ipv4_address, @ifconfig.netmask = line.captures(/ *inet (\d+(?:\.\d+){3}) netmask (.+) $/)
              end
            when /status\:/
              @ifconfig.status = line.capture(/ *status: (.+)$/)
            end
          else
            @ifconfigs << @ifconfig if @ifconfig
            @ifconfig = new
            @ifconfig.interface, _rest_of_line = line.captures(/^(.+?): (.+)$/)
          end
        end
        @ifconfigs << @ifconfig
      end
      alias_method :all, :parse
      alias_method :interfaces, :parse

      def interface_names
        all.collect(&:interface_name)
      end

      def active_interfaces
        all.select(&:active?)
      end
      alias_method :active, :active_interfaces

      def active_interfaces_names
        all.select(&:active?).collect(&:interface_name)
      end

      def inactive_interfaces
        all.select(&:inactive?)
      end
      alias_method :inactive, :inactive_interfaces

      def inactive_interfaces_names
        all.select(&:inactive?).collect(&:interface_name)
      end

      def up_interfaces
        all.select(&:up?)
      end
      alias_method :up, :up_interfaces

      def up_interfaces_names
        all.select(&:up?).collect(&:interface_name)
      end

      def mac_addresses
        all.collect(&:mac_address).compact
      end
      alias_method :ethernet_addresses, :mac_addresses

      def ipv4_addresses
        all.collect(&:ipv4_address).compact
      end

      def find_by_interface(interface)
        all.find{|ifconfig| ifconfig.interface == interface}
      end

      def find_by_mac_address(mac_address)
        all.find{|ifconfig| ifconfig.mac_address == mac_address}
      end

      def find_by_ipv4_address(ipv4_address)
        all.find{|ifconfig| ifconfig.ipv4_address == ipv4_address}
      end

      private

      def output
        `ifconfig -a`
      end

    end # class << self

    attr_accessor :interface
    attr_accessor :mac_address
    attr_accessor :ipv4_address, :netmask, :broadcast_address
    attr_accessor :status

    def initialize(interface: nil, mac_address: nil, ipv4_address: nil, netmask: nil, broadcast_address:nil, status: nil)
      @interface = interface
      @mac_address = mac_address
      @ipv4_address, @netmask, @broadcast_address = ipv4_address, netmask, broadcast_address
      @status = status
    end

    def interface_name
      @interface
    end
    alias_method :name, :interface_name

    def ethernet_address
      @mac_address
    end

    def active?
      @status == 'active'
    end

    def inactive?
      @status == 'inactive'
    end

    def up?
      active? || @ipv4_address
    end

  end
end

if __FILE__ == $0
  require 'pp'
  pp MacOS::IfConfig.interfaces
  p MacOS::IfConfig.interface_names
  p MacOS::IfConfig.active_interfaces
  p MacOS::IfConfig.active_interfaces_names
  p MacOS::IfConfig.inactive_interfaces
  p MacOS::IfConfig.inactive_interfaces_names
  p MacOS::IfConfig.up_interfaces
  p MacOS::IfConfig.up_interfaces_names
  p MacOS::IfConfig.mac_addresses
  p MacOS::IfConfig.ipv4_addresses
  p MacOS::IfConfig.find_by_interface('en0')
end
