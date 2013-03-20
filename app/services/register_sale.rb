class RegisterSale
  attr_accessor :params

  def initialize(params)
    @params = JSON.parse(params['payload'])
  end

  def create
    PaperTrail.whodunnit = user.id
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
      :name => "Register Sale #{params['invoice_number']}",
      :amount => params['totals']['total_payment'],
      :closes_on => params['sale_date'],
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

  def user
    @user ||=
      User.where(:email => params['user']['name']).first ||
      User.create(:email => params['user']['name'])
  end

end
