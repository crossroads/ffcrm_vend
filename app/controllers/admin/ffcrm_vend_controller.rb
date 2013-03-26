class Admin::FfcrmVendController < Admin::ApplicationController

  before_filter :require_user
  before_filter "set_current_tab('admin/ffcrm_vend')", :only => [ :index, :update ]

  # GET /admin/ffcrm_vend
  #----------------------------------------------------------------------------
  def index
    @vend_id = FfcrmVend.vend_id
    @user_id = FfcrmVend.user_id
    @sale_prefix = FfcrmVend.sale_prefix
    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def update
    @vend_id = params[:vend_id]
    @user_id = params[:user_id]
    @sale_prefix = (params[:sale_prefix] || "").strip

    if !@vend_id.present?
      flash[:error] = "Vend ID is reqired."
    elsif !@user_id.present?
      flash[:error] = "A default user is reqired."
    else
      FfcrmVend.settings = {:vend_id => @vend_id, :user_id => @user_id, :sale_prefix => @sale_prefix}
      flash[:info] = "Settings saved."
      redirect_to(:action => :index) and return
    end

    render :action => :index

  end

end
