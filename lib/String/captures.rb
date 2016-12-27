# Thoran/String/captures.rb
# Thoran::String#captures

# 20141002
# 0.1.0

# Changes:
# 1. + Thoran namespace.

module Thoran
  module String

    def captures(regex)
      if md = self.match(regex)
        md.captures
      else
        nil
      end
    end

  end
end

String.send(:include, Thoran::String)
