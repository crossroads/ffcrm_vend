class Admin::FfcrmVendController < Admin::ApplicationController

  before_filter :require_user
  before_filter "set_current_tab('admin/ffcrm_vend')", :only => [ :index, :update ]

  # GET /admin/ffcrm_vend
  #----------------------------------------------------------------------------
  def index
    @config = FfcrmVend.config
    @token = @config.token.blank? ? SecureRandom.urlsafe_base64 : @config.token
  end

  def update
    FfcrmVend.config.update!(params)
    flash[:info] = "Settings saved."
    redirect_to(:action => :index)
  end

end
