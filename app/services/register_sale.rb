class RegisterSale
  attr_accessor :params

  def initialize(params)
    @params = JSON.parse(params['payload'])
  end

  def create
    PaperTrail.whodunnit = user.try(:id)
    contact
    opportunity
    contact_opportunity
    comment
  end

  def contact
    @contact ||=
      Contact.where(:cf_vend_customer_id => params['customer_id']).first ||
      Contact.create(
        :first_name => params['customer']['contact_first_name'],
        :last_name => params['customer']['contact_last_name'],
        :cf_vend_customer_id => params['customer_id']
      )
  end

  def opportunity
    @opportunity ||= Opportunity.create(
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
  # If not found, use the default user
  def user
    @user ||=
      User.where(:email => params['user']['name']).first ||
      FfcrmVend.default_user
  end

end
