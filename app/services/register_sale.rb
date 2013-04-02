class RegisterSale
  attr_accessor :params

  def initialize(params)
    @params = JSON.parse(params['payload'])
    PaperTrail.whodunnit = user.try(:id)
  end

  def create
    if contact.present?
      ActiveRecord::Base.transaction do
        opportunity
        contact_opportunity
        comment
      end
    end
  end

  private

  #
  # Find a contact by looking for customer id.
  # Ensure excluded customers are not returned.
  # Ensure blank customer_id does not return results.
  # Otherwise, try to create a new contact object
  # If no customer name supplied then return nil
  #
  def contact
    return @contact if @contact.present?

    # Is contact in exclusion list?
    if (customer = params['customer']).present?
      first_name = customer['contact_first_name']
      last_name = customer['contact_last_name']
      return nil if FfcrmVend.is_customer_in_exclusion_list?(first_name, last_name)
    end

    @contact = Contact.where(:cf_vend_customer_id => params['customer_id']).first
    return @contact if @contact.present?

    if customer and first_name and last_name
      @contact = Contact.create( :first_name => first_name, :last_name => last_name, :cf_vend_customer_id => params['customer_id'] )
    else
      nil
    end
  end

  def opportunity
    @opportunity ||= Opportunity.create!(
      :name => "#{FfcrmVend.sale_prefix} #{params['invoice_number']}",
      :amount => params['totals']['total_payment'],
      :closes_on => params['sale_date'],
      :probability => 100,
      :stage => "won"
    )
  end

  def contact_opportunity
    @contact_opportunity ||= ContactOpportunity.create(
      :contact => contact,
      :opportunity => opportunity
    )
  end

  def comment
    url = FfcrmVend.vend_url
    url.path = "/sale/#{params['id']}"

    @comment ||= opportunity.comments.create(
      :user => user,
      :comment => url.to_s
    )
  end

  # Try to pick the user that called the update
  # If not found or user name is blank, use the default user
  def user
    return @user unless @user.nil?
    if (user_params = params['user']).present?
      name = user_params['name']
      @user = (User.where(:username => name).first || User.where(:email => name).first) if name.present?
    end
    @user ||= FfcrmVend.default_user
  end

end
