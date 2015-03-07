class Customer
  attr_accessor :params

  def initialize(params)
    @params = JSON.parse(params['payload'])
    FfcrmVend.log("Processing customer update #{@params}")
    PaperTrail.whodunnit = FfcrmVend.default_user.try(:id)
  end

  def create
    if contact.present?
      ActiveRecord::Base.transaction do
        contact_update
      end
    end
  end

  private

  #
  # Find a contact by looking for customer id, email address and phone number.
  # Ensure excluded customers are not returned.
  # Ensure blank customer_id / phone numbers / emails do not result in searches.
  # Otherwise, return a new contact object
  #
  def contact
    return @contact if @contact.present?

    # Is contact in exclusion list?
    if (contact = params['contact']).present?
      first_name = contact['first_name']
      last_name = contact['last_name']
      if FfcrmVend.is_customer_in_exclusion_list?(first_name, last_name)
        FfcrmVend.log('Customer is in exclusion list. Stopping!')
        return nil
      end
    end

    # Can we find a matching customer_id?
    id = params['id']
    @contact = Contact.where(:cf_vend_customer_id => id).first if id.present?
    unless @contact.nil?
      FfcrmVend.log('Found existing customer vend_id. Updating details')
      return @contact
    end

    # Can we find a matching email address?
    email = params['contact']['email']
    @contact = (Contact.where(:email => email).first || Contact.where(:alt_email => email).first) if email.present?
    if @contact
      FfcrmVend.log('Found existing customer email. Updating details')
      return @contact
    end

    # Can we find a matching phone number?
    phone = params['contact']['phone']
    @contact = Contact.where("phone = ? OR mobile = ?", phone, phone).first if phone.present?
    if @contact
      FfcrmVend.log('Found existing customer phone. Updating details')
      return @contact
    end

    FfcrmVend.log('Creating new customer')
    @contact = Contact.new
  end

  def contact_update
    contact.cf_vend_customer_id = params['id']
    if contact_params = params['contact']
      update_email(contact, params['contact']['email'])
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
  # If a new email address comes in, check whether it's already on the contacts record (search email and alt_email).
  # If it exists, then leave it alone.
  # If it doesn't exist then add it to alt_email (if email is already filled) or to contact.email if it's blank.
  #
  def update_email(contact, email_address)
    return unless email_address.present?
    unless [contact.email, contact.alt_email].compact.include?(email_address)
      if contact.email.blank?
        contact.email = email_address
      else
        contact.alt_email = email_address
      end
    end
  end

end
