# Thoran/String/Capture/capture.rb
# Thoran::String::Capture#capture

# 20171118
# 0.3.1

# Changes since 0.2:
# 1. + Thoran namespace.
# 0/1
# 2. Updated the MiniTest superclass only---no implementation changes.

module Thoran
  module String
    module Capture

      def capture(regex)
        if md = self.match(regex)
          md[1]
        else
          nil
        end
      end

    end
  end
end

String.send(:include, Thoran::String::Capture)
