class Admin::FfcrmVendController < Admin::ApplicationController

  before_filter :require_user
  before_filter "set_current_tab('admin/ffcrm_vend')", :only => [ :index, :update ]

  # GET /admin/ffcrm_vend
  #----------------------------------------------------------------------------
  def index
    @vend_id = FfcrmVend.vend_id
    @user_id = FfcrmVend.user_id
    @sale_prefix = FfcrmVend.sale_prefix
    @token = FfcrmVend.token || SecureRandom.urlsafe_base64
    @exclude_customers = FfcrmVend.exclude_customers.join("\n")
    @use_logger = FfcrmVend.use_logger?
    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def update
    @vend_id = params[:vend_id]
    @user_id = params[:user_id]
    @sale_prefix = (params[:sale_prefix] || "").strip
    @token = params[:token]
    @exclude_customers = params[:exclude_customers]
    @use_logger = params[:use_logger]

    if !@vend_id.present?
      flash[:error] = "Vend ID is reqired."
    elsif !@user_id.present?
      flash[:error] = "A default user is reqired."
    else
      FfcrmVend.settings = {:vend_id => @vend_id, :user_id => @user_id, :sale_prefix => @sale_prefix,
        :token => @token, :exclude_customers => @exclude_customers, :use_logger => @use_logger}
      flash[:info] = "Settings saved."
      redirect_to(:action => :index) and return
    end

    render :action => :index

  end

end
