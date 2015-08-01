Rails.application.routes.draw do

  post "/vend/customer_update" => "vend#customer_update", format: "json"
  post "/vend/register_sale"   => "vend#register_sale",   format: "json"

  post "/vend/customer_update_mq" => "vend#customer_update_mq", format: "json"
  post "/vend/register_sale_mq"   => "vend#register_sale_mq",   format: "json"

  get "/admin/ffcrm_vend" => "admin/ffcrm_vend#index",  format: "html"
  put "/admin/ffcrm_vend" => "admin/ffcrm_vend#update", format: "html"

end
