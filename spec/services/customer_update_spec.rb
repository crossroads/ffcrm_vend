require 'rails_helper'

describe 'Customer Update' do

  describe "contact" do

    it 'should find an existing contact by customer_id' do
      vend_customer_id = 'a3ccb1a1-8bc3-11e2-b1f5-4040782fde00'
      contact = FactoryGirl.create(:contact, :cf_vend_customer_id => vend_customer_id)
      payload = {'id' => vend_customer_id}

      customer = Customer.new('payload' => payload.to_json)
      expect(customer.send(:contact)).to eql(contact)
    end

    it 'should find an existing contact by email' do
      vend_customer_id = 'a3ccb1a1-8bc3-11e2-b1f5-4040782fde00'
      email = 'test@example.com'
      contact_params = {'email' => email}
      contact = FactoryGirl.create(:contact, :email => email)
      payload = {'id' => vend_customer_id, 'contact' => contact_params}

      customer = Customer.new('payload' => payload.to_json)
      expect(customer.send(:contact)).to eql(contact)
    end

    it 'should find an existing contact by alt_email' do
      vend_customer_id = 'a3ccb1a1-8bc3-11e2-b1f5-4040782fde00'
      email = 'test@example.com'
      contact_params = {'email' => email}
      contact = FactoryGirl.create(:contact, :alt_email => email)
      payload = {'id' => vend_customer_id, 'contact' => contact_params}

      customer = Customer.new('payload' => payload.to_json)
      expect(customer.send(:contact)).to eql(contact)
    end

    it 'should return a new contact' do
      payload = { 'id' => 'a3ccb1a1-8bc3-11e2-b1f5-4040782fde00', 'contact' => {'email' => 'test@example.com'} }
      customer = Customer.new('payload' => payload.to_json)
      expect(customer.send(:contact)).to be_new_record
    end

    it 'should return a new contact if customer_id is nil' do
      contact = FactoryGirl.create(:contact, :cf_vend_customer_id => nil)
      payload = { 'id' => nil, 'contact' => {'email' => 'test@example.com'} }
      customer = Customer.new('payload' => payload.to_json)
      expect(customer.send(:contact)).not_to eql(contact)
      expect(customer.send(:contact)).to be_new_record
    end

    it 'should return a new contact if customer_id and email are nil' do
      contact = FactoryGirl.create(:contact, :email => nil)
      payload = { 'id' => nil, 'contact' => {'email' => nil} }
      customer = Customer.new('payload' => payload.to_json)
      expect(customer.send(:contact)).not_to eql(contact)
      expect(customer.send(:contact)).to be_new_record
    end

    it "should return nil if the customer is on the exclusion list" do
      allow(FfcrmVend).to receive(:is_customer_in_exclusion_list?).and_return(true)
      contact = {'contact_first_name' => 'Bob', 'contact_last_name' => 'Jones'}
      sale = RegisterSale.new('payload' => {'contact' => contact}.to_json)
      expect(sale.send(:contact)).to eql(nil)
    end

  end

  describe "update_email" do

    it "should add email to contact's primary email field" do
      contact = Contact.new
      customer = Customer.new({'payload' => {'id' => nil}.to_json})
      customer.send('update_email', contact, 'test@example.com')
      expect(contact.email).to eql('test@example.com')
    end

    it "should add email to contact's alt_email field if neither email nor alt_email contain the new email" do
      contact = Contact.new(:email => 'noreply@example.com', :alt_email => 'really_no_reply@example.com')
      customer = Customer.new({'payload' => {'id' => nil}.to_json})
      customer.send('update_email', contact, 'test@example.com')
      expect(contact.email).to eql('noreply@example.com')
      expect(contact.alt_email).to eql('test@example.com')
    end

    it "should add email to contact's alt_email field" do
      contact = Contact.new(:email => 'bob@example.com')
      customer = Customer.new({'payload' => {'id' => nil}.to_json})
      customer.send('update_email', contact, 'test@example.com')
      expect(contact.email).to eql('bob@example.com')
      expect(contact.alt_email).to eql('test@example.com')
    end

    it "should not update if email already exists on contact" do
      contact = Contact.new(:email => 'bob@example.com', :alt_email => 'test@example.com')
      customer = Customer.new({'payload' => {'id' => nil}.to_json})
      customer.send('update_email', contact, 'bob@example.com')
      expect(contact.email).to eql('bob@example.com')
      expect(contact.alt_email).to eql('test@example.com')
    end

    it "should not add blank email" do
      contact = Contact.new(:email => 'bob@example.com', :alt_email => 'test@example.com')
      customer = Customer.new({'payload' => {'id' => nil}.to_json})
      customer.send('update_email', contact, '')
      expect(contact.email).to eql('bob@example.com')
      expect(contact.alt_email).to eql('test@example.com')
    end

  end

end
