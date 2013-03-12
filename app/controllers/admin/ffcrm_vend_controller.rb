class Admin::FfcrmVendController < Admin::ApplicationController

  before_filter :require_user
  before_filter "set_current_tab('admin/ffcrm_vend')", :only => [ :index, :update ]

  # GET /admin/ffcrm_vend
  #----------------------------------------------------------------------------
  def index
    @vend_id = RegisterSale.vend_id
    @email = RegisterSale.email
    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def update
    @vend_id = params[:vend_id]
    @email = params[:email]

    if !@vend_id.present?
      flash[:error] = "Vend ID is reqired."
    elsif !@email.present?
      flash[:error] = "Email is reqired."
    elsif !User.where(:email => @email.to_s).present?
      flash[:error] = "Email must represent a user in Fat Free CRM."
    else
      Setting[:ffcrm_vend] = {:vend_id => @vend_id, :email => @email}
      flash[:info] = "Settings saved."
      redirect_to(:action => :index) and return
    end

    render :action => :index

  end

end
