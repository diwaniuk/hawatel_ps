require 'spec_helper'

describe HawatelPS::Windows::ProcControl do
  let(:win32_data) { FactoryGirl.build(:win32_data) }
  let(:wmi_obj) { double 'WIN32OLE', :ole_respond_to? => 1, :Terminate => 0}

  before do
    allow(HawatelPS::Windows::ProcFetch).to receive(:get_process).and_return(Array.new([win32_data[:proc_attrs]]))
  end

  it '#state process is running' do
    allow(Process).to receive(:kill).and_return(1)
    process = HawatelPS::Windows::ProcTable.proc_table
    expect(process[0].status).to eq("running")
  end

  it '#state process is not running' do
    allow(Process).to receive(:kill).and_raise(Errno::ESRCH)
    process = HawatelPS::Windows::ProcTable.proc_table
    expect(process[0].status).to eq("not running")
  end

  it '#terminate process successful' do
    allow(@proc_attrs).to receive(:Terminate).and_return(0)
    allow(@proc_attrs).to receive(:ole_respond_to?).and_return(1)
    process = HawatelPS::Windows::ProcTable.proc_table
    expect(process[0].terminate).to eq(0)
  end

  it '#terminate process no successful' do
    allow(@proc_attrs).to receive(:Terminate).and_raise(WIN32OLERuntimeError)
    allow(@proc_attrs).to receive(:ole_respond_to?).and_return(1)
    process = HawatelPS::Windows::ProcTable.proc_table
    expect(process[0].terminate).to eq(1)
  end
end