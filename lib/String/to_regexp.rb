# String/to_regexp.rb
# String#to_regexp

# 20161120
# 0.3.0

# Changes:
# 1. Added a couple of aliases.

class String

  def to_regexp
    Regexp.new(Regexp.escape(self))
  end
  alias_method :to_regex, :to_regexp
  alias_method :to_re, :to_regexp
  alias_method :to_r, :to_regexp

end
