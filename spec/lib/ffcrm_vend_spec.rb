require 'rails_helper'

describe 'FfcrmVend' do

  describe "is_customer_in_exclusion_list?" do

    before do
      config = double('config')
      allow(config).to receive(:exclude_customers).and_return(['Bob Jones'])
      allow(FfcrmVend).to receive(:config).and_return(config)
    end

    it "should return true" do
      expect(FfcrmVend.is_customer_in_exclusion_list?('Bob', 'Jones')).to eql(true)
    end

    it "should return false" do
      expect(FfcrmVend.is_customer_in_exclusion_list?('Darth', 'Vader')).to eql(false)
    end

    it "should return false if empty name" do
      expect(FfcrmVend.is_customer_in_exclusion_list?('', '')).to eql(false)
    end

  end

end
