require 'spec_helper'

feature 'Customer Update' do

  let(:customer_json) { File.read(File.expand_path('../../fixtures/customer_update.json',__FILE__)) }
  let(:customer) { JSON.parse(customer_json) }

  scenario 'should create a contact for a new customer_id' do
    lambda {
      post('vend/customer_update', :payload => customer_json)
    }.should change(Contact, :count).by(1)

    contact = Contact.find_by_cf_vend_customer_id(customer['id'])
    contact.email.should eql(customer['contact']['email'])
    contact.first_name.should eql(customer['contact']['first_name'])
    contact.last_name.should eql(customer['contact']['last_name'])
    contact.phone.should eql(customer['contact']['phone'])

    address = contact.business_address
    address.street1.should eql(customer['contact']['physical_address1'])
    address.street2.should eql(customer['contact']['physical_address2'])
    suburb_city = "#{customer['contact']['physical_suburb']}, #{customer['contact']['physical_city']}"
    address.city.should eql(suburb_city)
    address.state.should eql(customer['contact']['physical_state'])
    address.zipcode.should eql(customer['contact']['physical_postcode'])
    address.country.should eql(customer['contact']['physical_country_id'])

  end

end
