class VendController < ActionController::Base

  before_action :authenticate

  def customer_update
    Customer.new(params).create
    respond_to do |format|
      format.json { render json: {} }
    end
  end

  def register_sale
    RegisterSale.new(params).create
    respond_to do |format|
      format.json { render json: {} }
    end
  end

  private

  # Note: this allows a blank token to effectively turn off authentication
  def authenticate
    unless FfcrmVend.config.token == params[:token]
      render plain: "", status: :unauthorized
    end
  end

end
