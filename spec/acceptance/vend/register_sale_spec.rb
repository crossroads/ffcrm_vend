require 'spec_helper'

feature 'Register Sale' do

  let(:register_sale) { JSON.parse(File.read(File.expand_path('../../fixtures/register_sale.json',__FILE__))) }

  scenario 'should create an account and opportunity for a new customer_id' do
    post('vend/register_sale', :payload => register_sale)

    response.should be_success
  end

end