class VendController < ActionController::Base

  respond_to :json

  def customer_update
    Customer.new(params).create
    respond_with({}, :location => nil)
  end

  def register_sale
    RegisterSale.new(params).create
    respond_with({}, :location => nil)
  end

end