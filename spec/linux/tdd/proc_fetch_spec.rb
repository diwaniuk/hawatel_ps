require 'spec_helper'
require 'ostruct'
require './spec/linux/support/stub_dir'
require './spec/linux/support/stub_file'

RSpec.configure do |config|
  config.include ProcFetch::StubDir
  config.include ProcFetch::StubFile
end


describe HawatelPS::Linux::ProcFetch do

  before(:each) do
    process_list  = ['1761']
    dir_exists
    file_readable
    process_list.each do |pid|
      dir_foreach({:pid => pid, :process_list => process_list})
      file_stat({:pid => pid})
      file_foreach({:pid => pid, :factories => 'spec/linux/factories'})
      file_ctime({:pid => pid})
      file_readlink({:pid => pid})
    end
  end

  let(:process) { HawatelPS::Linux::ProcFetch.get_process[0] }

  it "check pid attribute for process" do
    expect(process[:pid]).to be_a_kind_of(Integer)
  end

  it 'check attributes from /proc/<pid>/cwd' do
    expect(process[:cwd]).to match(/^\//)
  end

  it 'check attributes from /etc/passwd' do
    expect(process[:username]).to match(/\A/)
  end

  it 'check attributes from /proc/cmdline' do
    expect(process[:cmdline]).to_not be_nil
  end

  it 'check attributes from /proc/<pid>' do
    expect(process[:ctime]).to_not be_nil
  end

  it 'check attributes from /proc/<pid>/limits' do
    process[:limits].each do |limit|
      expect(limit[:name]).to match(/\A/)
      expect(limit[:soft]).to_not be_nil
      expect(limit[:hard]).to_not be_nil
    end
  end

  it 'check attributes from /proc/<pid>/environ' do
    expect(process[:environ][0]).to_not be_nil
  end

  it 'check attributes from /proc/<pid>/io' do
    expect(process[:wchar]).to be_a_kind_of(Integer)
    expect(process[:rchar]).to be_a_kind_of(Integer)
    expect(process[:syscr]).to be_a_kind_of(Integer)
    expect(process[:syscw]).to be_a_kind_of(Integer)
    expect(process[:read_bytes]).to be_a_kind_of(Integer)
    expect(process[:write_bytes]).to be_a_kind_of(Integer)
    expect(process[:cancelled_write_bytes]).to be_a_kind_of(Integer)
  end

  it 'check attributes from /proc/<pid>/fd/' do
    expect(process[:tty]).to_not be_nil
    expect(process[:open_files][0]).to_not be_nil
    expect(process[:listen_ports][0]).to_not be_nil
  end

  it 'check attributes from /proc/<pid>/status' do
    expect(process[:name]).to_not be_nil
    expect(process[:state]).to match(/^[a-z]*$/)
    expect(process[:ppid]).to be_a_kind_of(Integer)
    expect(process[:ruid]).to be_a_kind_of(Integer)
    expect(process[:euid]).to be_a_kind_of(Integer)
    expect(process[:suid]).to be_a_kind_of(Integer)
    expect(process[:fsuid]).to be_a_kind_of(Integer)
    expect(process[:gid]).to be_a_kind_of(Integer)
    expect(process[:egid]).to be_a_kind_of(Integer)
    expect(process[:sgid]).to be_a_kind_of(Integer)
    expect(process[:fsgid]).to be_a_kind_of(Integer)
    expect(process[:threads]).to be_a_kind_of(Integer)
    expect(process[:vmsize]).to be_a_kind_of(Integer)
    expect(process[:vmrss]).to be_a_kind_of(Integer)
    expect(process[:vmdata]).to be_a_kind_of(Integer)
    expect(process[:vmswap]).to be_a_kind_of(Integer)
    expect(process[:vmlib]).to be_a_kind_of(Integer)
    expect(process[:memory_percent]).to be_a_kind_of(Float)
  end

  it 'check attributes from /proc/<pid>/stat' do
    expect(process[:utime]).to be_a_kind_of(Integer)
    expect(process[:stime]).to be_a_kind_of(Integer)
    expect(process[:cpu_time]).to be_a_kind_of(Integer)
    expect(process[:cpu_percent]).to be_a_kind_of(Float)
  end



end
