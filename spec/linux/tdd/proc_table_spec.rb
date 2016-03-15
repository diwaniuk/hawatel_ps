require 'spec_helper'
require 'ostruct'
require './spec/linux/support/stub_dir'
require './spec/linux/support/stub_file'

RSpec.configure do |config|
  config.include ProcFetch::StubDir
  config.include ProcFetch::StubFile
end


describe HawatelPS::Linux::ProcTable do

  before(:each) do
    process_list  = ['1761']
    process_list.each do |pid|
      dir_exists
      dir_foreach({:pid => pid, :process_list => process_list})
      file_readable
      file_stat({:pid => pid})
      file_foreach({:pid => pid, :factories => 'spec/linux/factories'})
      file_ctime({:pid => pid})
      file_readlink({:pid => pid})
    end
  end


  it "return all process instances" do
    process = HawatelPS::Linux::ProcTable.proc_table
    expect(process[0].pid).to be_a_kind_of(Integer)
  end

  it "search process by name" do
     process = HawatelPS::Linux::ProcTable.search_by_name('java_fake')
     expect(process[0].pid).to be_a_kind_of(Integer)
  end

  it "search process by name using regex" do
    process = HawatelPS::Linux::ProcTable.search_by_name('/^java/')
    expect(process[0].pid).to be_a_kind_of(Integer)
  end

  it "search process by name using regex" do
    process = HawatelPS::Linux::ProcTable.search_by_name('/^jasdfsdfva/')
    expect { process[0].pid }.to raise_error(NoMethodError)
  end

  it "search process by pid" do
    process = HawatelPS::Linux::ProcTable.search_by_pid(1761)
    expect(process.pid).to eq(1761)
  end

  it "search process by condition == " do
    process = HawatelPS::Linux::ProcTable.search_by_condition(:attr => 'pid', :oper => '==', :value => '1761')
    expect(process[0].pid).to eq(1761)
  end

  it "search process by condition <= " do
    process = HawatelPS::Linux::ProcTable.search_by_condition(:attr => 'vmsize', :oper => '<=', :value => '3276257')
    expect(process[0].pid).to be_a_kind_of(Integer)
  end

  it "search process by condition >= " do
    process = HawatelPS::Linux::ProcTable.search_by_condition(:attr => 'vmsize', :oper => '>=', :value => '200000')
    expect(process[0].pid).to be_a_kind_of(Integer)
  end

  it "search process by condition != " do
    process = HawatelPS::Linux::ProcTable.search_by_condition(:attr => 'vmsize', :oper => '!=', :value => '200000')
    expect(process[0].pid).to be_a_kind_of(Integer)
  end

  it "search process by condition > " do
    process = HawatelPS::Linux::ProcTable.search_by_condition(:attr => 'vmsize', :oper => '>', :value => '200000')
    expect(process[0].pid).to be_a_kind_of(Integer)
  end

  it "search process by condition < " do
    process = HawatelPS::Linux::ProcTable.search_by_condition(:attr => 'vmsize', :oper => '<', :value => '6000000')
    expect(process[0].pid).to be_a_kind_of(Integer)
  end



end
