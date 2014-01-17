require 'spec_helper'

describe 'Register Sale' do

  describe "create" do

    describe "contact" do

      it "should find an existing contact" do
        vend_customer_id = 'a3ccb1a1-8bc3-11e2-b1f5-4040782fde00'
        contact = FactoryGirl.create(:contact, :cf_vend_customer_id => vend_customer_id)
        payload = {'customer_id' => vend_customer_id}

        sale = RegisterSale.new('payload' => payload.to_json)
        sale.send(:contact).should eql(contact)
      end

      it "should create a new contact with first_name, last_name and customer_id" do
        vend_customer_id = 'a3ccb1a1-8bc3-11e2-b1f5-4040782fde00'
        customer = {'contact_first_name' => 'Bob', 'contact_last_name' => 'Jones'}
        payload = {'customer_id' => vend_customer_id, 'customer' => customer}

        contact = RegisterSale.new('payload' => payload.to_json).send(:contact)
        contact.first_name.should eql(customer['contact_first_name'])
        contact.last_name.should eql(customer['contact_last_name'])
        contact.cf_vend_customer_id.should eql(vend_customer_id)
      end

      it "should return nil if the customer is on the exclusion list" do
        FfcrmVend.stub(:is_customer_in_exclusion_list?).and_return(true)
        customer = {'contact_first_name' => 'Bob', 'contact_last_name' => 'Jones'}
        sale = RegisterSale.new('payload' => {'customer' => customer}.to_json)
        sale.send(:contact).should be_nil
      end

      it "should not create a customer if there are no customer params" do
        sale = RegisterSale.new('payload' => {}.to_json)
        sale.send(:contact).should be_nil
      end

      it "should not create a customer if there is no first name" do
        sale = RegisterSale.new('payload' => {'customer' => {'contact_last_name' => 'Test'}}.to_json)
        sale.send(:contact).should be_nil
      end

      it "should not create a customer if there is no last name" do
        sale = RegisterSale.new('payload' => {'customer' => {'contact_first_name' => 'Test'}}.to_json)
        sale.send(:contact).should be_nil
      end

    end

    describe "opportunity" do

      before(:each) do
        @closes_on = '2013-03-27'
        FfcrmVend.stub(:sale_prefix).and_return('Test Sale')
        payload = {'invoice_number' => '15', 'sale_date' => @closes_on, 'totals' => {'total_payment' => '5'}, 'user' => {'name' => 'test@example.com'} }
        @sale = RegisterSale.new('payload' => payload.to_json)
      end

      it do
        @sale.send(:opportunity).name.should eql("Test Sale 15")
      end
      it do
        @sale.send(:opportunity).amount.to_i.should eql(5)
      end
      it do
        @sale.send(:opportunity).closes_on.should eql(Date.parse(@closes_on))
      end
      it do
        @sale.send(:opportunity).probability.should eql(100)
      end
      it do
        @sale.send(:opportunity).stage.should eql('won')
      end

    end

    describe "user" do

      it 'should find an existing user by email' do
        user = FactoryGirl.create(:user)
        payload = {'user' => {'name' => user.email} }
        sale = RegisterSale.new('payload' => payload.to_json)
        sale.send(:user).should == user
      end

      it 'should find an existing user by username' do
        user = FactoryGirl.create(:user)
        payload = {'user' => {'name' => user.username} }
        sale = RegisterSale.new('payload' => payload.to_json)
        sale.send(:user).should == user
      end

      it 'should use the default user when it cannot find intended user' do
        user = FactoryGirl.create(:user)
        FfcrmVend.stub(:default_user).and_return(user)
        payload = {'user' => {'name' => 'none@example.com'} }
        sale = RegisterSale.new('payload' => payload.to_json)
        sale.send(:user).should == user
      end

      it 'should use the default user if email is blank' do
        user = FactoryGirl.create(:user, :email => 'user@example.com')
        bad_user = FactoryGirl.create(:user)
        bad_user.update_column(:email, '')
        FfcrmVend.stub(:default_user).and_return(user)
        payload = {'user' => {'name' => ''} }
        sale = RegisterSale.new('payload' => payload.to_json)
        sale.send(:user).should == user
      end

      it 'should use the default user if user params are blank' do
        user = FactoryGirl.create(:user, :email => 'user@example.com')
        FfcrmVend.stub(:default_user).and_return(user)
        sale = RegisterSale.new('payload' => {}.to_json)
        sale.send(:user).should == user
      end

    end

  end

end
