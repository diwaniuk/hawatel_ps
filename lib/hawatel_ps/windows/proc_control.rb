module HawatelPS
  module Windows
    class ProcControl

      # Check current process status
      #
      # @example
      #   p = HawatelPS.search_by_name('notepad.exe')
      #   p.status
      #
      # @return [String] 'running' or 'not running'
      def status
        Process.kill 0, @proc_attrs[:processid].to_i
        return "running"
      rescue Errno::ESRCH
        return "not running"
      rescue Errno::EPERM
        return 'non-privilaged operation'
      end

      # Suspend process without loss data
      #
      # @example
      #   p = HawatelPS.search_by_pid('1020')
      #   p.suspend
      #
      # @return [String]
      def suspend
        # TODO There is no SuspendProcess API function in Windows.
        # This was described in article: http://www.codeproject.com/Articles/2964/Win-process-suspend-resume-tool
        # The suspend method isn't not save
      end


      # Resume suspended process
      # @example
      #   p = HawatelPS.search_by_pid('1020')
      #   p.resume
      # @return [String]
      def resume
        # TODO There is no ResumeProcess API function in Windows.
        # This was described in article: http://www.codeproject.com/Articles/2964/Win-process-suspend-resume-tool
        # The resume method isn't not save
      end


      # Terminate process
      # @example
      #   p = HawatelPS.search_by_pid('1020')
      #   p.terminate
      # @return [Integer] return source: https://msdn.microsoft.com/en-us/library/windows/desktop/aa393907
      #   * Successful completion (0)
      #   * Process not found (1)
      #   * Access denied (2)
      #   * Insufficient privilege (3)
      #   * Unknown failure (8)
      #   * Path not found (9)
      #   * Invalid parameter (21)
      #   * Other (22–4294967295)
      def terminate
        return @proc_attrs[:wmi_object].Terminate if @proc_attrs[:wmi_object].ole_respond_to?('Terminate')
      rescue WIN32OLERuntimeError => ex
        #raise HawatelPSException, :exception => ex, :message => "Cannot terminate process by WMI method Terminate()."
        return 1
      end

    end
  end
end
