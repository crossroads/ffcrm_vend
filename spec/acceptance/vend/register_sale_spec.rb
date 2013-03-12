require 'spec_helper'

feature 'Register Sale' do

  let(:register_sale) { JSON.parse(File.read(File.expand_path('../../fixtures/register_sale.json',__FILE__))) }

  scenario 'should create a contact and opportunity for a new customer_id' do
    # First sale you a customer id should create an contact
    lambda {
      post('vend/register_sale', :payload => register_sale)
    }.should change(Contact, :count).by(1)

    # Subsequent sales should attach to the same contact
    lambda {
      post('vend/register_sale', :payload => register_sale)
    }.should_not change(Contact, :count).by(1)

    opportunity = Opportunity.last
    opportunity.name.should eql("Register Sale #{register_sale["invoice_number"]}")

    comment = opportunity.comments.first
    comment.comment.should include("/sale/#{register_sale['id']}")

    response.should be_success
  end

end
