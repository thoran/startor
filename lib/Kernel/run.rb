# Kernel/run.rb
# Kernel#run

# 20260301
# 0.3.0

# Changes since 0.2:
# -/0: + Allow capture of output from issued command.
# 1. + capture: keyword argument to return command output instead of success boolean.
# 2. Check for capture being true and issue wtih backticks instead of using system().

module Kernel

  def run(*command, capture: false, dry_run: false, show: false, raise_on_failure: true)
    if show
      if dry_run
        puts "DRY RUN *** #{command.join(' ')} *** DRY RUN"
      else
        puts command.join(' ')
      end
    end
    unless dry_run
      if capture
        output = `#{command.join(' ')}`.strip
        if !$?.success? && raise_on_failure
          raise "#{command.inspect} failed with exit code #{$?.exitstatus}."
        end
        output # Return the output of issuing the command.
      else
        system(*command)
        success = $?.success?
        if !success && raise_on_failure
          raise "#{command.inspect} failed with exit code #{$?.exitstatus}."
        end
        success # Return the success or failure of issuing the command.
      end
    else # Dry runs always succeed.
      true
    end
  end

end
