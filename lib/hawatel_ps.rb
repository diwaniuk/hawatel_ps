require "hawatel_ps/version"
require "hawatel_ps/linux" if RUBY_PLATFORM =~ /linux/
require "hawatel_ps/windows" if RUBY_PLATFORM =~ /mswin|msys|mingw|cygwin|bccwin|wince|emc/
require "hawatel_ps/shared/hawatelps_exception"

module HawatelPS

  def self.search_by_pid(pid)
    HawatelPS::platform::ProcTable.search_by_pid(pid)
  end

  def self.search_by_name(name)
    HawatelPS::platform::ProcTable.search_by_name(name)
  end

  def self.search_by_condition(args)
    HawatelPS::platform::ProcTable.search_by_condition(args)
  end

  def self.proc_table
    HawatelPS::platform::ProcTable.proc_table
  end

  def self.platform
    if RUBY_PLATFORM =~ /linux/
      Linux
    elsif RUBY_PLATFORM =~ /mswin|msys|mingw|cygwin|bccwin|wince|emc/
      Windows
    else
      raise HawatelPSException.new({:message => "Your OS(#{RUBY_PLATFORM}) is not supported!"})
    end
  end

end