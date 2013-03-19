Rails.application.routes.draw do

  match "/vend/customer_update" => "vend#customer_update", :format => :json
  match "/vend/register_sale" => "vend#register_sale", :format => :json

  match "/admin/ffcrm_vend" => "admin/ffcrm_vend#index",  :via => :get,  :format => :html
  match "/admin/ffcrm_vend" => "admin/ffcrm_vend#update", :via => :post, :format => :html

end
