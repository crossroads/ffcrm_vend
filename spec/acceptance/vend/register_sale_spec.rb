require 'spec_helper'

feature 'Register Sale' do

  let(:register_sale) { JSON.parse(File.read(File.expand_path('../../fixtures/register_sale.json',__FILE__))) }

  scenario 'should create an account and opportunity for a new customer_id' do
    # First sale you a customer id should create an account
    lambda {
      post('vend/register_sale', :payload => register_sale)
    }.should change(Account, :count).by(1)

    # Subsequent sales should attach to the same Account
    lambda {
      post('vend/register_sale', :payload => register_sale)
    }.should_not change(Account, :count).by(1)

    opportunity = Opportunity.last
    opportunity.name.should eql("Register Sale 144")

    comment = opportunity.comments.first
    comment.comment.should eql("https://globalhandicrafts.vendhq.com/sale/5e8b5134-a002-dd6b-b7c7-26126887c4ee")

    response.should be_success
  end

end