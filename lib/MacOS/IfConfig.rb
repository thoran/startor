# MacOS/IfConfig.rb
# MacOS::IfConfig

# 20260125
# 0.7.0

# Changes since 0.6:
# -/0: Add support for virtual/tunnel interfaces (utun, etc.) via flag parsing and enhanced up? detection. Add interface control methods for bringing down and destroying interfaces. Add pattern matching for finding groups of interfaces.
# 1. + require 'Kernel/run'
# 2. + require 'Regexp/to_regexp'
# 3. + require 'String/to_regexp'
# 4. ~ parse(): Parse flags from interface header line to support virtual interfaces.
# 5. + alias_method :all_interfaces, :parse
# 6. + all_matching(pattern): Find all interfaces matching a pattern.
# 7. + bring_down_interface(interface_name): Bring down a specific interface.
# 8. + bring_down_matching_interfaces(pattern): Bring down all interfaces matching a pattern.
# 9. + destroy_interface(interface_name): Destroy a specific interface.
# 10. + attr_accessor :flags
# 11. ~ initialize(): Add flags parameter.
# 12. ~ up?(): Check both physical (status-based) and virtual (flags-based) interfaces.
# 13. + virtual?(): Detect if interface is virtual/tunnel interface.

require 'Kernel/run'
require 'Regexp/to_regexp'
require 'String/to_regexp'
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
                ipv4_address_from, ipv4_address_to, @ifconfig.netmask = line.captures(/inet (.+) --> (.+) netmask (.+)$/)
                @ifconfig.ipv4_address = ipv4_address_from
              else
                @ifconfig.ipv4_address, @ifconfig.netmask = line.captures(/ *inet (\d+(?:\.\d+){3}) netmask (.+) $/)
              end
            when /status\:/
              @ifconfig.status = line.capture(/ *status: (.+)$/)
            end
          else
            @ifconfigs << @ifconfig if @ifconfig
            @ifconfig = new
            @ifconfig.interface, rest_of_line = line.captures(/^(.+?): (.+)$/)
            if rest_of_line =~ /flags=\w+<([^>]+)>/
              @ifconfig.flags = $1.split(',')
            end
          end
        end
        @ifconfigs << @ifconfig
      end
      alias_method :all, :parse
      alias_method :interfaces, :parse
      alias_method :all_interfaces, :parse

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

      def all_matching(pattern)
        pattern = pattern.to_regexp
        all.select{|ifconfig| ifconfig.name =~ pattern}
      end

      def bring_down_interface(interface_name)
        run('sudo', 'ifconfig', interface_name, 'down')
      end

      def bring_down_matching_interfaces(pattern)
        matching_interfaces = all_matching(pattern).select(&:up?)
        matching_interfaces.each do |ifconfig|
          bring_down_interface(ifconfig.name)
        end
        matching_interfaces.map(&:name)
      end

      def destroy_interface(interface_name)
        run('sudo', 'ifconfig', interface_name, 'destroy')
      end

      # private

      def output
        `ifconfig -a`
      end
    end # class << self

    attr_accessor(
      :broadcast_address,
      :flags,
      :interface,
      :ipv4_address,
      :mac_address,
      :netmask,
      :status
    )

    def initialize(
      broadcast_address: nil,
      flags: nil,
      interface: nil,
      ipv4_address: nil,
      mac_address: nil,
      netmask: nil,
      status: nil
    )
      @broadcast_address = broadcast_address
      @flags = flags
      @interface = interface
      @ipv4_address = ipv4_address
      @mac_address = mac_address
      @netmask = netmask
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

    # For interfaces with status field (physical), check active status and IP address.
    # For interfaces with flags only (virtual), check UP flag and IP address.
    def up?
      if @status
        active? && @ipv4_address
      else
        (@flags && @flags.include?('UP')) && @ipv4_address
      end
    end

    def virtual?
      @interface =~ /^(utun|awdl|llw|lo|bridge|gif|stf)\d*/
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
