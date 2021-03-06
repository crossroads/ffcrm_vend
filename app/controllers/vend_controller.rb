require 'cgi'

class VendController < ActionController::Base

  respond_to :json
  before_filter :authenticate

  def customer_update
    Customer.new(params).create
    respond_with({}, :location => nil)
  end

  def register_sale
    RegisterSale.new(params).create
    respond_with({}, :location => nil)
  end

  # Takes input from an IronMQ queue, if you like that sort of thing
  def customer_update_mq
    body = CGI::parse(request.body.read)
    data = { 'payload' => body['payload'][0] }
    Customer.new(data).create
    respond_with({}, :location => nil, :status => 200)
  end

  # Takes input from an IronMQ queue, if you like that sort of thing
  def register_sale_mq
    body = CGI::parse(request.body.read)
    data = { 'payload' => body['payload'][0] }
    RegisterSale.new(data).create
    respond_with({}, :location => nil, :status => 200)
  end

  private

  # Note: this allows a blank token to effectively turn off authentication
  def authenticate
    unless FfcrmVend.config.token == params[:token]
      render :text => "", :status => :unauthorized
    end
  end

end
