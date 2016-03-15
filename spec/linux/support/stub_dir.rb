module ProcFetch
  module StubDir
    # Stub Dir.foreach method for fake /proc directory
    #
    # @example
    # dir_foreach({:pid => '1761', :process_list => ['1768', '123']'})
    #
    # @return
    def dir_foreach(args)
      pid = args[:pid] || 1
      procs_list = args[:process_list]
      allow(Dir).to receive(:foreach) do |dir|
        if dir == '/proc'
          procs_list
        elsif dir == "/proc/#{pid}/fd"
          ['0','1','2','3']
        end
      end
    end


    # Stub Dir.exist? method
    #
    # @example
    # dir_exist()
    #
    # @return [Boolen]
    def dir_exists
      allow(Dir).to receive(:exist?).and_return(true)
    end

  end
end