require 'spec_helper'

describe HawatelPS::Linux::ProcFetch do

  it "list processes" do
    processes = HawatelPS.proc_table
    processes.each do |process|
      expect(process.pid).to be_a_kind_of(Integer)
    end
    expect(processes.size).to be >= 2
  end

  it "search process by pid" do
    pid = child(5)
    process = HawatelPS.search_by_pid(pid)
    expect(process[:pid]).to eq(pid)
  end

  it "search process by name" do
    pid = child(5)
    child_exist = 0
    processes = HawatelPS.search_by_name('/ruby/')
    processes.each do |process|
      child_exist= 1 if process.pid == pid
    end
    expect(processes.size).to be >= 1
    expect(child_exist).to eq(1)
  end

  it "search process by condition" do
    processes = HawatelPS.search_by_condition(:attr => 'pid', :oper => '>', :value => '1'  )
    expect(processes.size).to be >= 2
  end

  it "suspend & resume and terminate process" do
    pid = child(5)
    process = HawatelPS.search_by_pid(pid)
    suspend_status = process.suspend
    resume_status = process.resume
    terminate_status = process.terminate
    expect(suspend_status).to eq('stopped')
    expect(resume_status).to match(/(sleeping|running)/)
    expect(terminate_status).to match(/(terminated|zombie)/)
  end

end

private
  def child(timeout)
    pid = fork do
      sleep(timeout)
      exit
    end
  end