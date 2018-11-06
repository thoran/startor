# IfConfig.rb
# IfConfig

# 20161227
# 0.0.0

require 'String/captures'

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

if __FILE__ == $0
  require 'pp'
  ic = IfConfig.new
  pp ic.send(:parse)
  ic.interfaces
  ic.active_interfaces
end
