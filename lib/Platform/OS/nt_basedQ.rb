# Platform/OS/nt_basedQ.rb
# Platform::OS#nt_based?

module Platform

  module_function

  def nt_based?
    if ENV.has_key?('OS') && ENV['OS'] =~ /nt/i # it's one of the NT-based operating systems (NT, 2000, or XP) (What about Vista, 7, and 8?)
      true
    else # it's one of DOS, Windows 95, 98, or ME
      false
    end
  end

end
