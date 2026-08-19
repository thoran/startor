# Thoran/File/GsubX/gsubX.rb
# Thoran::File::GsubX#gsub!

# 20260819
# 0.5.1

# Description: Rewrites an open file in place, substituting within the lines which match, and leaving the rest as they are.
#
# A String pattern is literal text: it is escaped, so a String of '[a-z].' finds those seven characters and nothing else.  A Regexp is used as given.  That is the whole of the difference between the two, and it is why a String which looks like a pattern does not behave as one.
#
# selection_pattern chooses the lines to touch, and defaults to replacement_pattern, so the common case of "change this text wherever it appears" needs two arguments and the case of "change this text, but only on lines which look like that" needs three.

# Changes since 0.5.0:
# 1. The description above, which had said "replaces any text it finds according to a regular expression" since before 0.3.3.  Escaping was added at 0.3.3 — "I wasn't until now escaping the patterns" — and the String and Regexp branches came later still, at which point a String stopped being a pattern and the description stopped being true.
# 2. - Regexp.new() around selection_pattern and replacement_pattern inside the loop.  Both are already Regexp by the time the loop runs, having been made so above, so this rebuilt each of them once per line.
# 3. ~ the two bare raises, which gave a RuntimeError with nothing in it, now ArgumentError naming the argument and what it was given.
# 4. + test/gsubX_test.rb.  There had been no test since 0.4.0, and the suite dropped then had been failing since 0.3.3, which is how escaping came to be a surprise.

module Thoran
  module File
    module GsubX

      def gsub!(replacement_pattern, replacement_text, selection_pattern = nil)
        replacement_pattern = to_pattern(replacement_pattern, :replacement_pattern)
        selection_pattern = replacement_pattern unless selection_pattern
        selection_pattern = to_pattern(selection_pattern, :selection_pattern)

        lines = []
        rewind
        each_line do |line|
          if line =~ selection_pattern
            lines << line.gsub(replacement_pattern, replacement_text)
          else
            lines << line
          end
        end
        truncate(0)
        rewind
        write lines.join
      end

      private

      # A String is literal text and so is escaped; a Regexp is a pattern and is
      # taken as it stands.
      def to_pattern(pattern, name)
        case pattern
        when String; Regexp.new(Regexp.escape(pattern))
        when Regexp; pattern
        else; raise ArgumentError, "#{name} takes a String or a Regexp, and was given a #{pattern.class}."
        end
      end

    end
  end
end

File.send(:include, Thoran::File::GsubX)
