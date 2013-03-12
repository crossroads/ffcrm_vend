class RegisterSale
  attr_accessor :params

  def initialize(params)
    @params = params[:payload]
  end

  def create
    contact
    opportunity
    contact_opportunity
    comment
  end

  def contact
    @contact ||=
      Contact.where(:cf_vend_customer_id => params[:customer_id].to_s).first ||
      Contact.create(
        :first_name => "Contact for Register Sale",
        :last_name => "Inv #{params[:invoice_number]}",
        :cf_vend_customer_id => params[:customer_id]
      )
  end

  def opportunity
    @opportunity ||= Opportunity.create(
      :name => "Register Sale #{params[:invoice_number]}",
      :amount => params[:totals][:total_payment],
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
    url = RegisterSale.vend_url
    url.path = "/sale/#{params[:id]}"

    @comment ||= opportunity.comments.create(
      :user => user,
      :comment => url.to_s
    )
  end

  def user
    @user ||= User.where(:email => RegisterSale.email).first || User.create(:email => RegisterSale.email)
  end

  class << self

    def vend_url
      URI("https://#{vend_id}.vendhq.com/")
    end

    def vend_id
      'globalhandicrafts'
    end

    def email
      'marketplace@crossroads.org.hk'
    end

  end # class

end
