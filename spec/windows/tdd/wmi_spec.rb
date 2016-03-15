require 'spec_helper'
require 'ostruct'

describe HawatelPS::Windows::WmiCli do
  let(:win32_data) { FactoryGirl.build(:win32_data) }
  let(:wmi_ole) { double 'WIN32OLE', :properties_ => Array.new([OpenStruct.new(:name => 'name', :value => 'rubymine')])}
  let(:instance) { double 'HawatelPS::Windows::WmiCli::Instance' }

  before do
    allow(WIN32OLE).to receive(:new).with('WbemScripting.SWbemLocator').and_return(wmi_ole)
  end

  it 'query results success' do
    allow_connect_server
    allow(wmi_ole).to receive(:execMethod_).with('GetOwner')
                          .and_return(OpenStruct.new(:User => 'asmith', :Domain => 'test'))

    obj = HawatelPS::Windows::WmiCli.new.query('SELECT * FROM Win32_Process')[0]
    expect(obj.class).to eq(HawatelPS::Windows::WmiCli::Instance)
    expect(obj.wmi_ole_object).to eq(wmi_ole)
    expect(obj.properties[:name]).to eq('rubymine')

    owner = obj.execMethod('GetOwner')
    expect(owner.User).to eq('asmith')
    expect(owner.Domain).to eq('test')
  end

  it 'query raise exception' do
    allow(wmi_ole).to receive(:ConnectServer).and_return(wmi_ole)
    allow(wmi_ole).to receive(:ExecQuery).with('SELECT * FROM Win32_ERROR').and_raise(WIN32OLERuntimeError)

    expect{HawatelPS::Windows::WmiCli.new.query('SELECT * FROM Win32_ERROR')}
        .to raise_error(HawatelPS::Windows::WmiCliException)
  end

  it 'ConnectServer raise exception' do
    allow(wmi_ole).to receive(:ConnectServer).and_raise(WIN32OLERuntimeError)

    expect{HawatelPS::Windows::WmiCli.new.query('SELECT * FROM Win32_Process')}
        .to raise_error(HawatelPS::Windows::WmiCliException)
  end

  it '#execMethod raise exception' do
    allow_connect_server
    allow(wmi_ole).to receive(:execMethod_).with('GetOwner').and_raise(WIN32OLERuntimeError)

    obj = HawatelPS::Windows::WmiCli.new.query('SELECT * FROM Win32_Process')[0]
    expect { obj.execMethod('GetOwner') }.to raise_error(HawatelPS::Windows::WmiCliException)
  end

  private

  def allow_connect_server
    allow(wmi_ole).to receive(:ExecQuery).with('SELECT * FROM Win32_Process').and_return(Array.new([wmi_ole]))
    allow(wmi_ole).to receive(:ConnectServer).and_return(wmi_ole)
    allow(wmi_ole).to receive(:ole_respond_to?).and_return(true)
  end

end