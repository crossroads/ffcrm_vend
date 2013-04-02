require 'spec_helper'

describe 'FfcrmVend' do

  describe "exclude_customers" do

    it "should return a list of customers" do
      Setting.stub!(:ffcrm_vend).and_return( {:exclude_customers => "Bob Jones\nSteve Jobs"} )
      FfcrmVend.exclude_customers.should eql(['Bob Jones', 'Steve Jobs'])
    end

    it "should return empty list if no settings saved" do
      Setting.stub!(:ffcrm_vend).and_return( nil )
      FfcrmVend.exclude_customers.should eql([])
    end

    it "should return empty list if empty setting saved" do
      Setting.stub!(:ffcrm_vend).and_return( {:exclude_customers => ""} )
      FfcrmVend.exclude_customers.should eql([])
    end

    it "should remove blank lines" do
      Setting.stub!(:ffcrm_vend).and_return( {:exclude_customers => "Bob Jones\n\n\nSteve Jobs"} )
      FfcrmVend.exclude_customers.should eql(['Bob Jones', 'Steve Jobs'])
    end

    it "should not return duplicates" do
      Setting.stub!(:ffcrm_vend).and_return( {:exclude_customers => "Bob Jones\nSteve Jobs\nBob Jones"} )
      FfcrmVend.exclude_customers.should eql(['Bob Jones', 'Steve Jobs'])
    end

  end

  describe "is_customer_in_exclusion_list?" do

    it "should return true" do
      FfcrmVend.stub!(:exclude_customers).and_return(['Bob Jones'])
      FfcrmVend.is_customer_in_exclusion_list?('Bob', 'Jones').should be_true
    end

    it "should return false" do
      FfcrmVend.stub!(:exclude_customers).and_return(['Bob Jones'])
      FfcrmVend.is_customer_in_exclusion_list?('Darth', 'Vader').should be_false
    end

    it "should return false if empty name" do
      FfcrmVend.stub!(:exclude_customers).and_return(['Bob Jones'])
      FfcrmVend.is_customer_in_exclusion_list?('', '').should be_false
    end

  end

end
