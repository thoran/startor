# Thoran/Module/AliasMethods/alias_methods.rb
# Thoran::Module::AliasMethods#alias_methods

# 20180806
# 0.1.0

# Description: I have a penchance for having multiple method names and having line after line of alias_method calls is kinda ugly.  

require 'Array/all_but_last'

module Thoran
  module Module
    module AliasMethods

      def alias_methods(*args)
        args.all_but_last.each{|e| alias_method e.to_sym, args.last.to_sym}
      end

    end
  end
end

Module.send(:include, Thoran::Module::AliasMethods)
