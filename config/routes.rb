Rails.application.routes.draw do

	match "/vend/register_sale" => "vend#register_sale", :format => :json

end
