module HawatelPS
  module Linux
    class ProcControl

      # Check current process status
      # @example
      #   p = HawatelPS.search_by_name('top')
      #   p.status
      #
      # @return [String] - current process status (running, stopped ..)
      def status
        sleep(0.2)
        status_file = "/proc/#{@proc_attrs[:pid]}/status"
        if File.readable?(status_file)
          File.foreach(status_file).each do |attr|
            return attr.split(' ')[2].chop[1..-1] if attr =~ /State:/
          end
        end
        'terminated'
      end

      # Suspend process without loss data (equal to Kill -SIGSTOP <pid> command)
      #
      # @example
      #   p = HawatelPS.search_by_name('top')
      #   p.suspend
      #
      # @return [String] - current process status (running, stopped ..)
      def suspend
        process_status = status
        if process_status != 'terminated' && process_status != 'stopped'
          return status if Process.kill('STOP', @proc_attrs[:pid].to_i)
        end
        process_status
      rescue Errno::EPERM
        return 'non-privilaged operation'
      end

      # Resume suspended process (equal to Kill -SIGCONT <pid> command)
      #
      # @example
      #   p = HawatelPS.search_by_name('top')
      #   p.resume
      #
      # @return [String] - current process status (running, stopped ..)
      def resume
        process_status = status
        if process_status  == 'stopped'
          return status if Process.kill('CONT', @proc_attrs[:pid].to_i)
        end
        process_status
      rescue Errno::EPERM
        return 'non-privilaged operation'
      end

      # Kill process (equal to Kill -SIGKILL <pid> command)
      #
      # @example
      #   p = HawatelPS.search_by_name('top')
      #   p.kill
      #
      # @return [String] - current process status (running, stopped ..)
      def terminate
        process_status = status
        if process_status != 'terminated'
          return status if Process.kill('KILL', @proc_attrs[:pid])
        end
        process_status
      rescue Errno::EPERM
        return 'non-privilaged operation'
      end

    end
  end
end
