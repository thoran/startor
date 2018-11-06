# String#each

# 20120330
# 0.0.0

# Description: Ruby 1.9 no longer mixes in Enumerable, so here's String's missing #each method.  See String#each_line and String#each_char for the specific implementations.  

require 'String/each_char'
require 'String/each_line'

class String
  
  def each(unit = :line, &block)
    case unit
    when :line; each_line(&block)
    when :char; each_char(&block)
    end
  end
  
end
