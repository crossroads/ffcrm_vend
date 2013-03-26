require 'spec_helper'

feature 'Register Sale' do

  let(:register_sale_json) { File.read(File.expand_path('../../fixtures/register_sale.json',__FILE__)) }
  let(:register_sale) { JSON.parse(register_sale_json) }

  scenario 'should create a contact and opportunity for a new customer_id' do
    # First sale you a customer id should create an contact
    lambda {
      post('vend/register_sale', :payload => register_sale_json)
    }.should change(Contact, :count).by(1)

    # Subsequent sales should attach to the same contact
    lambda {
      post('vend/register_sale', :payload => register_sale_json)
    }.should_not change(Contact, :count).by(1)

    opportunity = Opportunity.last
    opportunity.name.should eql("#{FfcrmVend.sale_prefix} #{register_sale["invoice_number"]}")
    opportunity.closes_on.should eql(Date.parse(register_sale['sale_date']))
    opportunity.probability.should eql(100)

    comment = opportunity.comments.first
    comment.comment.should include("/sale/#{register_sale['id']}")
    user = FfcrmVend.default_user
    comment.user.should eql(user)

    response.should be_success
  end

end
