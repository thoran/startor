# Kernel/run.rb
# Kernel#run

# 20170613
# 0.1.5

# Changes:
# 1. Make use of a number of options, substituting ENV['DRY_RUN'] for options[:dry_run], and adding :show and :dont_raise.
# 0/1
# 2. When showing the output make it clear that it is a dry run.
# 1/2
# 3. If the :dry_run option is specified, then it makes no sense to test $? for success, so group all that code in the unless.
# 2/3
# 4. The logic was reversed for whether to raise or not.
# 3/4
# 5. Really fixed the raise logic finally, I think.
# 4/5
# 6. Yet another attempt at fixing the raise logic.

# Todo:
# 1. Even though this is a small method it might be good idea to add some automated tests.

require 'Array/extract_optionsX'

module Kernel

  def run(*args)
    options = args.extract_options!
    command = args
    if options[:show] && !options[:dry_run]
      puts command.join(' ')
    elsif options[:show] && options[:dry_run]
      puts "DRY RUN *** #{command.join(' ')} *** DRY RUN"
    end
    unless options[:dry_run]
      system(*command)
      if !$?.success? && !options[:dont_raise]
        raise "#{command.inspect} failed to exit cleanly."
      end
    end
  end

end
