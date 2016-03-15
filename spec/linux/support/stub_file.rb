module ProcFetch
  module StubFile
    # Stub File.stat method
    #
    # @example
    # file_stat({:pid => '1761'})
    #
    # @return
    def file_stat(args)
      pid = args[:pid] || 1
      allow(File).to receive(:stat) do |file|
        if file == "/proc/#{pid}"
          OpenStruct.new({:uid => 1000})
        end
      end
    end


    # Stub File.foreach method
    #
    # @example
    # dir_foreach({:pid => '1761', :factories => 'spec/linux/factories'})
    #
    # @return
    def file_foreach(args)
      pid    = args[:pid] || 1
      factor = args[:factories] || 'spec/linux/factories/'
      allow(File).to receive(:foreach) do |file|
        if file == '/proc/meminfo'
          File.readlines("#{factor}/proc/meminfo")
        elsif file == "/proc/#{pid}/environ"
          File.readlines("#{factor}/proc/#{pid}/environ")
        elsif file == "/proc/#{pid}/status"
          File.readlines("#{factor}/proc/#{pid}/status")
        elsif file == "/proc/#{pid}/stat"
          File.readlines("#{factor}/proc/#{pid}/stat")
        elsif file == "/proc/#{pid}/io"
          File.readlines("#{factor}/proc/#{pid}/io")
        elsif file == "/proc/#{pid}/limits"
          File.readlines("#{factor}/proc/#{pid}/limits")
        elsif file == "/proc/#{pid}/cmdline"
          File.readlines("#{factor}/proc/#{pid}/cmdline")
        elsif file == "/etc/passwd"
          File.readlines("#{factor}/etc/passwd")
        elsif file == "/proc/net/tcp"
          File.readlines("#{factor}/proc/net/tcp")
        elsif file == "/proc/net/udp"
          File.readlines("#{factor}/proc/net/udp")
        elsif file == "/proc/uptime"
          File.readlines("#{factor}/proc/uptime")
        end
      end
    end


    # Stub File.ctime method
    #
    # @example
    # file_ctime({:pid => '1761'})
    #
    # @return
    def file_ctime(args)
      pid = args[:pid] || 1
      allow(File).to receive(:ctime) do |file|
        if file == "/proc/#{pid}"
          Time.at(1457266080)
        end
      end
    end


    # Stub File.readable? method
    #
    # @example
    # file_readable()
    #
    # @return
    def file_readable
      allow(File).to receive(:readable?).and_return(true)
    end


    # Stub File.readlink method
    #
    # @example
    # file_readlink({:pid => '1761'})
    #
    # @return
    def file_readlink(args)
      pid = args[:pid] || 1
      allow(File).to receive(:readlink) do |file|
        if file == "/proc/#{pid}/cwd"
          '/home/daniel'
        elsif file == "/proc/#{pid}/fd/0"
          '/dev/pts/3'
        elsif file == "/proc/#{pid}/fd/1"
          '/home/daniel/.cache/lxsession/Lubuntu/run.log'
        elsif file == "/proc/#{pid}/fd/2"
          'socket:[21181]'
        elsif file == "/proc/#{pid}/fd/3"
          'anon_inode:[eventfd]'
        end
      end
    end

  end
end