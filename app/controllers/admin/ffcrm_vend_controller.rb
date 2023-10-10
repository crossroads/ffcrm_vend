class Admin::FfcrmVendController < Admin::ApplicationController

  before_action :require_user
  before_action only: [:index, :update] do
    set_current_tab('admin/ffcrm_vend')
  end

  # GET /admin/ffcrm_vend
  #----------------------------------------------------------------------------
  def index
    @config = FfcrmVend.config
    @token = @config.token.blank? ? SecureRandom.urlsafe_base64 : @config.token
  end

  def update
    FfcrmVend.config.update!(params)
    flash[:info] = "Settings saved."
    redirect_to(action: "index")
  end

end
