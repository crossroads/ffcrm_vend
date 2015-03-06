require 'rails_helper'

describe 'FfcrmVend::Config' do

  let(:config) { FfcrmVend::Config.new }
  let(:settings) { {:vend_id => '12345', :user_id => 'admin', :sale_prefix => "Sale", :token => 'XYZ', :exclude_customers => "steve\njohn", :use_logger => true} }
  before { allow(Setting).to receive(:ffcrm_vend).and_return(settings) }

  it "should return the endpoint" do
    expect(config.vend_id).to eql(settings[:vend_id])
    expect(config.user_id).to eql(settings[:user_id])
    expect(config.sale_prefix).to eql(settings[:sale_prefix])
    expect(config.token).to eql(settings[:token])
    expect(config.exclude_customers).to eql(settings[:exclude_customers].split("\n"))
    expect(config.use_logger?).to eql(true)
  end

  it "should update the settings" do
    expect(Setting).to receive('ffcrm_vend=') do |args|
      expect(args[:vend_id]).to eql('54321')
      expect(args[:user_id]).to eql('nimda')
      expect(args[:sale_prefix]).to eql('New sale') # does a strip
      expect(args[:token]).to eql('ZYX')
      expect(args[:exclude_customers]).to eql("steph\njim")
      expect(args[:use_logger]).to eq(false)
    end
    config.update!(:vend_id => '54321', :user_id => 'nimda', :sale_prefix => " New sale ", :token => 'ZYX', :exclude_customers => "steph\njim", :use_logger => '0')
  end

  describe "exclude_customers" do

    it "should return a list of customers" do
      expect(Setting).to receive(:ffcrm_vend).and_return(:exclude_customers => "Bob Jones\nSteve Jobs")
      expect(config.exclude_customers).to eql(['Bob Jones', 'Steve Jobs'])
    end

    it "should return empty list if no settings saved" do
      expect(Setting).to receive(:ffcrm_vend).and_return(nil)
      expect(config.exclude_customers).to eql([])
    end

    it "should return empty list if empty setting saved" do
      expect(Setting).to receive(:ffcrm_vend).and_return(:exclude_customers => "")
      expect(config.exclude_customers).to eql([])
    end

    it "should remove blank lines" do
      expect(Setting).to receive(:ffcrm_vend).and_return(:exclude_customers => "Bob Jones\n\n\nSteve Jobs")
      expect(config.exclude_customers).to eql(['Bob Jones', 'Steve Jobs'])
    end

    it "should not return duplicates" do
      expect(Setting).to receive(:ffcrm_vend).and_return(:exclude_customers => "Bob Jones\nSteve Jobs\nBob Jones")
      expect(config.exclude_customers).to eql(['Bob Jones', 'Steve Jobs'])
    end

  end

end
