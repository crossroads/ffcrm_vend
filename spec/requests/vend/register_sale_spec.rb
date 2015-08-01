require "rails_helper"

RSpec.describe VendController, type: "controller" do

  let(:register_sale_json) { File.read(File.expand_path('../../fixtures/register_sale.json',__FILE__)) }
  let(:register_sale) { JSON.parse(register_sale_json) }

  it 'should create a contact and opportunity for a new customer_id' do
    # First sale you a customer id should create an contact
    expect {
      post :register_sale, format: "json", payload: register_sale_json
    }.to change(Contact, :count).by(1)

    # Subsequent sales should attach to the same contact
    expect {
      post :register_sale, format: "json", payload: register_sale_json
    }.to change(Contact, :count).by(0)

    opportunity = Opportunity.last
    expect(opportunity.name).to eql("#{FfcrmVend.config.sale_prefix} #{register_sale["invoice_number"]}")
    expect(opportunity.closes_on).to eql(Date.parse(register_sale['sale_date']))
    expect(opportunity.probability).to eql(100)

    comment = opportunity.comments.first
    expect(comment.comment).to include("/sale/#{register_sale['id']}")
    user = FfcrmVend.default_user
    expect(comment.user).to eql(user)
  end

  it 'rejected token' do
    Setting.ffcrm_vend = Setting.ffcrm_vend.merge(:token => SecureRandom.urlsafe_base64)
    post :register_sale, format: "json", payload: register_sale_json, token: 'XYZ'
    expect(response.response_code).to eql(401)
  end

end
