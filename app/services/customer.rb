class Customer
  attr_accessor :params

  def initialize(params)
    @params = JSON.parse(params['payload'])
  end

  def create
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
    contact.save
  end
end