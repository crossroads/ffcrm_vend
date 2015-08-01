require "rails_helper"

RSpec.describe VendController, type: "controller" do

  let(:customer_json) { File.read(File.expand_path('../../fixtures/customer_update.json',__FILE__)) }
  let(:customer) { JSON.parse(customer_json) }

  it 'should create a contact for a new customer_id' do
    expect {
      post :customer_update, format: "json", payload: customer_json
    }.to change(Contact, :count).by(1)

    contact = Contact.find_by_cf_vend_customer_id(customer['id'])
    expect(contact.email).to eql(customer['contact']['email'])
    expect(contact.first_name).to eql(customer['contact']['first_name'])
    expect(contact.last_name).to eql(customer['contact']['last_name'])
    expect(contact.phone).to eql(customer['contact']['phone'])

    address = contact.business_address
    expect(address.street1).to eql(customer['contact']['physical_address1'])
    expect(address.street2).to eql(customer['contact']['physical_address2'])
    suburb_city = "#{customer['contact']['physical_suburb']}, #{customer['contact']['physical_city']}"
    expect(address.city).to eql(suburb_city)
    expect(address.state).to eql(customer['contact']['physical_state'])
    expect(address.zipcode).to eql(customer['contact']['physical_postcode'])
    expect(address.country).to eql(customer['contact']['physical_country_id'])
  end

  it 'rejected token' do
    Setting.ffcrm_vend = Setting.ffcrm_vend.merge(:token => SecureRandom.urlsafe_base64)
    post(:customer_update, format: "json", payload: customer_json, token: 'XYZ')
    expect(response.response_code).to eql(401)
  end

end
