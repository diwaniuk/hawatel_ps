require 'spec_helper'

describe HawatelPS do
  context '#search_by_pid' do
    it 'process found' do
      name = 'PING.EXE'
      pid = child(20)
      proc = HawatelPS.search_by_pid(pid)
      expect(proc).not_to be_nil
      expect_proc_attrs(proc, {:pid => pid, :name => name})
    end

    it 'process not found' do
      proc = HawatelPS.search_by_pid(-1)
      expect(proc).to be_nil
    end
  end

  context '#search_by_name' do
    it 'process found' do
      name = 'PING.EXE'
      pid = child(20)
      procs = HawatelPS.search_by_name(name)

      expect(procs).not_to be_nil
      expect(find_proc(procs, pid, name)).to eq(true)

    end

    it 'process not found' do
      proc = HawatelPS.search_by_name("_____________procss_not_exists_____________")
      expect(proc).to be_nil
    end
  end

  context '#search_by_condition' do
    it 'process found' do
      pid = child(20)
      processes = HawatelPS.search_by_condition(:attr => 'processid', :oper => '>', :value => "#{pid}" )
      expect(processes.size).to be >= 2
    end

    it 'process not found' do
      processes = HawatelPS.search_by_condition(:attr => 'processid', :oper => '=', :value => '-1'  )
      expect(processes).to be_nil
    end
  end

  context '#proc_table' do
    let(:procs) { HawatelPS.proc_table }
    let(:name) { 'PING.EXE' }

    it 'process found' do
      pid = child(20)
      expect(find_proc(procs, pid, name)).to eq(true)

    end

    it 'processes not found' do
      expect(find_proc(procs, -1, name)).to eq(false)
    end
  end


  context HawatelPS::Windows::ProcControl do
    it '#terminate successful' do
        pid = child(20)
        proc = HawatelPS.search_by_pid(pid)
        status = proc.terminate
        expect(status).to eq(0)
    end

    it '#terminate no successful' do
      pid = child(20)
      proc = HawatelPS.search_by_pid(pid)
      proc.terminate
      sleep 1
      status = proc.terminate
      expect(status).not_to eq(0)
    end

    it '#state running' do
      pid = child(20)
      proc = HawatelPS.search_by_pid(pid)
      status = proc.status
      expect(status).to eq("running")
    end
  end

end

private

def expect_proc_attrs(proc, args)
  expect(proc.processid.to_i).to eq(args[:pid])
  expect(proc.name.downcase).to eq(args[:name].downcase)
  expect(proc.sid).to be_a(String)
  expect(proc.wmi_object).to be_a(WIN32OLE)
  expect(proc.user).not_to be_nil
  expect(proc.domain).not_to be_nil
  expect(proc.availablevirtualsize.to_i).to be >= 0
  expect(proc.cpupercent.to_f).to be >= 0
  expect(proc.memorypercent.to_f).to be >= 0
end

def find_proc(procs, pid, name)
  proc_found = false
  procs.each do |proc|
    if proc.processid.to_i == pid
      proc_found = true
      expect_proc_attrs(proc, {:pid => pid, :name => name})
    end
  end
  return proc_found
end

def child(timeout)
  pid = spawn('PING.EXE', "127.0.0.1", "-n", timeout.to_s,  "-w", "10000", :out => "NUL")
end