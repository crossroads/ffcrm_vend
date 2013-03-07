class RegisterSale
	attr_accessor :params

	def initialize(params)
		@params = params[:payload]
	end

	def create
		account
		opportunity
		account_opportunity
		comment
	end

	def account
		@account ||= 
			Account.find_by_cf_vend_customer_id(params[:customer_id]) ||
			Account.create(
				:name => "Account for Register Sale #{params[:invoice_number]}",
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

	def account_opportunity
		@account_opportunity ||= AccountOpportunity.create(
			:account => account,
			:opportunity => opportunity
		)
	end

	def comment
		@comment ||= opportunity.comments.create(
			:user => user,
			:comment => "https://globalhandicrafts.vendhq.com/sale/#{params[:id]}"
		)
	end

	def user
		@user ||= User.find_by_email('marketplace@crossroads.org.hk') ||
			User.create(:email => 'marketplace@crossroads.org.hk')
	end
end