class Customer
  attr_accessor :params

  def initialize(params)
    @params = JSON.parse(params['payload'])
  end

  def create
    PaperTrail.whodunnit = user.try(:id)
    contact
    contact_update
  end

  def contact
    @contact ||=
      Contact.where(:cf_vend_customer_id => params['id']).first ||
      Contact.where(:email => params['contact']['email']).first ||
      Contact.new
  end

  def contact_update
    contact.cf_vend_customer_id = params['id']
    if contact_params = params['contact']
      contact.email = contact_params['email'] unless contact_params['email'].blank?
      contact.first_name = contact_params['first_name'] unless contact_params['first_name'].blank?
      contact.last_name = contact_params['last_name'] unless contact_params['last_name'].blank?
      contact.phone = contact_params['phone'] unless contact_params['phone'].blank?
    end

    # Set address if none exists
    if contact.business_address.blank?
      street1 = params['contact']['physical_address1']
      street2 = params['contact']['physical_address2']
      suburb = params['contact']['physical_suburb']
      city = params['contact']['physical_city']
      city = "#{suburb}, #{city}" if suburb
      state = params['contact']['physical_state']
      zipcode = params['contact']['physical_postcode']
      country = params['contact']['physical_country_id']

      if Setting.compound_address
        address = Address.new(:street1 => street1, :street2 => street2, :city => city,
          :state => state, :zipcode => zipcode, :country => country, :address_type => "Business")
      else
        address = Address.new(:full_address => "#{street1}\n#{street2}\n#{city}\n#{state}\n#{zipcode}\n#{country}")
      end

      contact.business_address = address unless address.blank?
    end
    contact.save
  end

  #
  # Customer update webhook doesn't include params['user'] so we use the Vend default instead
  #
  def user
    @user ||= FfcrmVend.default_user
  end

end
