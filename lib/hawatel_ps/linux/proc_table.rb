module HawatelPS
  module Linux
    class ProcTable
      class << self

        # Return attributes of searched process based on pid
        #
        # @example
        #  search_by_pid(1761)
        #
        # @param [Integer] pid of process
        # @return [ProcInfo] hash with process attributes
        def search_by_pid(pid)
          refresh
          @proc_table.each do |process|
            return process if process.pid.to_s == pid.to_s
          end
          return nil
        end

        # Return attributes of searched process based on name or cmdline
        #
        # @example
        #   search_by_name('java')
        #   search_by_name('/^regex/')
        #
        # @param process_name[String] name of process
        # @return [Array<ProcInfo>] array of ProcInfo objects
        def search_by_name(process_name)
          refresh
          process_list = Array.new
          if process_name =~ /^\/.*\/$/
            process_name.slice!(0)
            process_name = Regexp.new(/#{process_name.chop}/)
          end
          @proc_table.each do |process|
           if process_name.is_a? Regexp
             process_list << process if process.name =~ process_name || process.cmdline =~ process_name
           else
             process_list << process if process.name == "#{process_name}" || process.cmdline == "#{process_name}"
           end
          end
          return process_list
        end

        # Return attributes of searched process based on specified condition
        #
        # @example
        #   search_by_condition(:attrs => 'vmsize', :oper => '<', value => '10000')
        #
        # @param args[Hash] attributes for search condition
        # @option :attr [String], name of process attribute (first expression for if)
        # @option :oper [String], operatator, available options: >,<,>=,<=,==,!=
        # @option :value [String], value comparable (second expression for if)
        #
        # @return [Array<ProcInfo>] array of ProcInfo objects
        def search_by_condition(args)
          refresh
          attr = args[:attr]
          oper  = args[:oper]
          value = args[:value]
          process_list = Array.new
          @proc_table.each do |process|
            value = value.to_i if process[:"#{attr}"].is_a? Fixnum
            value = value.to_f if process[:"#{attr}"].is_a? Float
            if oper == '>'
              process_list << process if process[:"#{attr}"] > value if process[:"#{attr}"]
            elsif oper == '<'
              process_list << process if process[:"#{attr}"] < value if process[:"#{attr}"]
            elsif oper == '>='
              process_list << process if process[:"#{attr}"] >= value if process[:"#{attr}"]
            elsif oper == '<='
              process_list << process if process[:"#{attr}"] <= value if process[:"#{attr}"]
            elsif oper == '=='
              process_list << process if process[:"#{attr}"] == value if process[:"#{attr}"]
            elsif oper == '!='
              process_list << process if process[:"#{attr}"] != value if process[:"#{attr}"]
            end
          end
          return process_list
        end

        # Return all process instances
        #
        # @example
        #   proc_table()
        #
        # @return [Array<ProcInfo>] array of ProcInfo objects
        def proc_table
          refresh
          return @proc_table
        end

        private
        # Refresh list of current running processes
        #
        # @example
        #   refresh()
        #
        # @return [Array<ProcInfo>] array of ProcInfo objects
        def refresh
          @proc_table = Array.new
          ProcFetch.get_process.each do |proc_attrs|
            @proc_table.push(ProcInfo.new(proc_attrs))
          end
          childs_tree
        end

        # Find and add childs attribute for process
        #
        def childs_tree
          @proc_table.each do |proc_parent|
            @proc_table.each do |proc_child|
              if proc_parent.pid == proc_child.ppid
                proc_parent[:childs].push(proc_child)
              end
            end
          end
        end

      end
    end
  end
end