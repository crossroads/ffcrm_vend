Rails.application.routes.draw do
  post "/vend/customer_update" => "vend#customer_update", defaults: { format: "json" }
  post "/vend/register_sale"   => "vend#register_sale",   defaults: { format: "json" }

  post "/vend/customer_update_mq" => "vend#customer_update_mq", defaults: { format: "json" }
  post "/vend/register_sale_mq"   => "vend#register_sale_mq",   defaults: { format: "json" }

  get "/admin/ffcrm_vend" => "admin/ffcrm_vend#index",  defaults: { format: "html" }
  put "/admin/ffcrm_vend" => "admin/ffcrm_vend#update", defaults: { format: "html" }
end
