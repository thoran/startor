# Thoran/String/Capture/capture.rb
# Thoran::String::Capture#capture

# 20161109
# 0.3.0

# Changes since 0.2:
# 1. + Thoran namespace.

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
