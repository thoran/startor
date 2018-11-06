# Array/extract_optionsX.rb
# Array#extract_options!

# 20140402
# 0.1.1

# History: Stolen wholesale from ActiveSupport.

# Changes:
# 1. + #extract_options (no exclamation).  Whereas I had previously had #extract_options mean the same as what I now call #peek_options, I decided that Array has some precedents for method names which do not have a bang method, but which do modify the receiver in place; #shift, #unshift, #push, and #pop come to mind...
# 0/1
# 2. Some minor tidying.

class Array

  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end
  alias_method :extract_options, :extract_options!

end
