require 'spec_helper'

describe HawatelPS::Windows::ProcTable do
  let(:win32_data) { FactoryGirl.build(:win32_data) }

  before do
    allow(HawatelPS::Windows::ProcFetch).to receive(:get_process).and_return(Array.new([win32_data[:proc_attrs]]))
  end


  it "return all process instances" do
    process = HawatelPS::Windows::ProcTable.proc_table
    expect(process[0].processid).to match(/^[0-9]+$/)
  end

  it "return proc attributes" do
    process = HawatelPS::Windows::ProcTable.proc_table
    expect(process[0].each).to be_a(Enumerator)
  end

  it "search process by name" do
    process = HawatelPS::Windows::ProcTable.search_by_name('rubymine.exe')
    expect(process[0].processid).to match(/^[0-9]+$/)
  end

  it "search process by name using regex" do
    process = HawatelPS::Windows::ProcTable.search_by_name('/^ruby/')
    expect(process[0].processid).to match(/^[0-9]*$/)
  end

  it "search process by name using regex with raise error" do
    process = HawatelPS::Windows::ProcTable.search_by_name('/^jasdfsdfva/')
    expect { process[0].pid }.to raise_error(NoMethodError)
  end

  it "search process by pid" do
    process = HawatelPS::Windows::ProcTable.search_by_pid(9336)
    expect(process.processid).to eq('9336')
  end

  it "search process by condition == " do
    process = HawatelPS::Windows::ProcTable.search_by_condition(:attr => 'processid', :oper => '==', :value => '9336')
    expect(process[0].processid).to eq('9336')
  end

  it "search process by condition <= " do
    process = HawatelPS::Windows::ProcTable.search_by_condition(:attr => 'workingsetsize', :oper => '<=', :value => '437301248')
    expect(process[0].processid).to match(/^[0-9]*$/)
  end

  it "search process by condition >= " do
    process = HawatelPS::Windows::ProcTable.search_by_condition(:attr => 'workingsetsize', :oper => '>=', :value => '200000')
    expect(process[0].processid).to match(/^[0-9]*$/)
  end

  it "search process by condition != " do
    process = HawatelPS::Windows::ProcTable.search_by_condition(:attr => 'workingsetsize', :oper => '!=', :value => '200000')
    expect(process[0].processid).to match(/^[0-9]*$/)
  end

  it "search process by condition > " do
    process = HawatelPS::Windows::ProcTable.search_by_condition(:attr => 'workingsetsize', :oper => '>', :value => '200000')
    expect(process[0].processid).to match(/^[0-9]*$/)
  end

  it "search process by condition < " do
    process = HawatelPS::Windows::ProcTable.search_by_condition(:attr => 'workingsetsize', :oper => '<', :value => '537301248')
    expect(process[0].processid).to match(/^[0-9]*$/)
  end

end