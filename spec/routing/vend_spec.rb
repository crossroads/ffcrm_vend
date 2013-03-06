require 'spec_helper'

describe VendController do
  describe "routing" do
    it "generates register_sale route for vend" do
      { :get => "/vend/register_sale" }.should route_to(:controller => "vend", :action => "register_sale", :format => :json)
    end
  end
end