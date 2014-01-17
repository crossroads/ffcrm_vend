require 'spec_helper'

describe FfcrmVend::Config do

  let(:config) { FfcrmVend::Config.new }
  let(:settings) { {:vend_id => '12345', :user_id => 'admin', :sale_prefix => "Sale", :token => 'XYZ', :exclude_customers => "steve\njohn", :use_logger => true} }
  before { Setting.stub(:ffcrm_vend).and_return(settings) }

  it "should return the endpoint" do
    config.vend_id.should == settings[:vend_id]
    config.user_id.should == settings[:user_id]
    config.sale_prefix.should == settings[:sale_prefix]
    config.token.should == settings[:token]
    config.exclude_customers.should == settings[:exclude_customers].split("\n")
    config.should be_use_logger
  end

  it "should update the settings" do
    Setting.should_receive('ffcrm_vend=') do |args|
      args[:vend_id].should == '54321'
      args[:user_id].should == 'nimda'
      args[:sale_prefix].should == 'New sale' # does a strip
      args[:token].should == 'ZYX'
      args[:exclude_customers].should == "steph\njim"
      args[:use_logger].should be_false # boolean conversion
    end
    config.update!(:vend_id => '54321', :user_id => 'nimda', :sale_prefix => " New sale ", :token => 'ZYX', :exclude_customers => "steph\njim", :use_logger => '0')
  end

  describe "exclude_customers" do

    it "should return a list of customers" do
      Setting.stub(:ffcrm_vend).and_return(:exclude_customers => "Bob Jones\nSteve Jobs")
      config.exclude_customers.should eql(['Bob Jones', 'Steve Jobs'])
    end

    it "should return empty list if no settings saved" do
      Setting.stub(:ffcrm_vend).and_return(nil)
      config.exclude_customers.should eql([])
    end

    it "should return empty list if empty setting saved" do
      Setting.stub(:ffcrm_vend).and_return(:exclude_customers => "")
      config.exclude_customers.should eql([])
    end

    it "should remove blank lines" do
      Setting.stub(:ffcrm_vend).and_return(:exclude_customers => "Bob Jones\n\n\nSteve Jobs")
      config.exclude_customers.should eql(['Bob Jones', 'Steve Jobs'])
    end

    it "should not return duplicates" do
      Setting.stub(:ffcrm_vend).and_return(:exclude_customers => "Bob Jones\nSteve Jobs\nBob Jones")
      config.exclude_customers.should eql(['Bob Jones', 'Steve Jobs'])
    end

  end

end
