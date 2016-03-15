require 'spec_helper'
require 'ostruct'

describe HawatelPS::Windows::ProcFetch do
  let(:win32_data) { FactoryGirl.build(:win32_data) }
  let(:wmi_cli) { double 'HawatelPS::Windows::WmiCli' }
  let(:native_wmi_obj) { double 'WIN32OLE'}
  let(:wmi_object) { double 'HawatelPS::Windows::WmiCli::Instance',
                            :properties => win32_data[:proc_attrs],
                            :wmi_ole_object => native_wmi_obj}
  let(:user_sid) { prepare_owner_sid_as_struct(win32_data[:users]) }
  let(:user_struct) { prepare_user_info_as_struct(win32_data[:users]) }
  let(:system_info_struct) { OpenStruct.new(:properties => {:totalvisiblememorysize => "8388608"})}
  let(:system_idle_struct) { OpenStruct.new(:properties => {:kernelmodetime => "500592031250"})}

  before do
  allow(HawatelPS::Windows::WmiCli).to receive(:new).and_return(wmi_cli)
  win32_data[:proc_attrs][:wmi_object] = native_wmi_obj

  allow(wmi_cli).to receive(:query).with('SELECT * FROM Win32_Process').and_return(Array.new([wmi_object]))
  allow(wmi_cli).to receive(:query).with('SELECT * FROM Win32_UserAccount').and_return(Array.new([user_struct]))
  allow(wmi_cli).to receive(:query).with('SELECT * FROM Win32_OperatingSystem').and_return(Array.new([system_info_struct]))
  allow(wmi_cli).to receive(:query).with("SELECT KernelModeTime FROM Win32_Process WHERE ProcessId = '0'").and_return(Array.new([system_idle_struct]))

  allow(wmi_object).to receive(:execMethod).with('GetAvailableVirtualSize').and_return(
      OpenStruct.new(:AvailableVirtualSize => win32_data[:proc_attrs][:availablevirtualsize]))
  end

  it '#get_process' do
    allow(wmi_object).to receive(:execMethod).with('GetOwnerSid').and_return(user_sid)

    proc_table = HawatelPS::Windows::ProcFetch.get_process

    expect(proc_table[0]).to eq(win32_data[:proc_attrs])
  end

  it '#get_owner_sid raise error' do
    allow(wmi_object).to receive(:execMethod).with('GetOwnerSid').and_raise(HawatelPS::Windows::WmiCliException)
    proc_table = HawatelPS::Windows::ProcFetch.get_process
    expect(proc_table[0][:sid]).to be_nil
  end

  it '#get_avail_virtual_size raise error' do
    allow(wmi_object).to receive(:execMethod).with('GetOwnerSid').and_return(user_sid)
    allow(wmi_object).to receive(:execMethod).with('GetAvailableVirtualSize').and_raise(HawatelPS::Windows::WmiCliException)
    proc_table = HawatelPS::Windows::ProcFetch.get_process
    expect(proc_table[0][:availablevirtualsize]).to be_nil
  end

  it '#cpu_percent return 0' do
    allow(wmi_object).to receive(:execMethod).with('GetOwnerSid').and_return(user_sid)
    allow(HawatelPS::Windows::ProcFetch).to receive(:cpu_time).and_return(0)

    proc_table = HawatelPS::Windows::ProcFetch.get_process

    expect(proc_table[0][:cpupercent]).to eq("0.0")
  end

end

private

def prepare_user_info_as_struct(user_info)
  user_struct = OpenStruct.new
  user_struct.properties = user_info
  return user_struct
end

def prepare_owner_sid_as_struct(user_info)
  sid_struct = OpenStruct.new
  sid_struct.Sid = user_info[:sid]
  return sid_struct
end