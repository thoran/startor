# Thoran/String/Captures/captures.rb
# Thoran::String::Captures#captures

# 20171118
# 0.3.0

# Changes:
# 1. Returning an empty array when there's no match, since that's more consistent.

module Thoran
  module String
    module Captures

      def captures(regex)
        if md = self.match(regex)
          md.captures
        else
          []
        end
      end

    end
  end
end

String.send(:include, Thoran::String::Captures)
