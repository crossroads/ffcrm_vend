require 'spec_helper'

describe 'FfcrmVend' do

  describe "is_customer_in_exclusion_list?" do

    before do
      config = mock('config')
      config.stub!(:exclude_customers).and_return(['Bob Jones'])
      FfcrmVend.stub!(:config).and_return(config)
    end

    it "should return true" do
      FfcrmVend.is_customer_in_exclusion_list?('Bob', 'Jones').should be_true
    end

    it "should return false" do
      FfcrmVend.is_customer_in_exclusion_list?('Darth', 'Vader').should be_false
    end

    it "should return false if empty name" do
      FfcrmVend.is_customer_in_exclusion_list?('', '').should be_false
    end

  end

end
