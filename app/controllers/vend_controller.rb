class VendController < ActionController::Base

	respond_to :json

	def register_sale
		RegisterSale.new(params).create
		respond_with({}, :location => nil)
	end

end