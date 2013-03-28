require 'spec_helper'

describe VendController do
  describe "routing" do

    describe "register_sale" do
      it "POST json" do
        { :post => "/vend/register_sale" }.should route_to(:controller => "vend", :action => "register_sale", :format => :json)
      end
      it "GET json" do
        { :get => "/vend/register_sale" }.should_not route_to(:controller => "vend", :action => "register_sale", :format => :json)
      end
    end

    describe "register_sale_mq" do
      it "POST json" do
        { :post => "/vend/register_sale_mq" }.should route_to(:controller => "vend", :action => "register_sale_mq", :format => :json)
      end
      it "GET json" do
        { :get => "/vend/register_sale_mq" }.should_not route_to(:controller => "vend", :action => "register_sale_mq", :format => :json)
      end
    end

    describe "customer_update" do
      it "POST json" do
        { :post => "/vend/customer_update" }.should route_to(:controller => "vend", :action => "customer_update", :format => :json)
      end
      it "GET json" do
        { :get => "/vend/customer_update" }.should_not route_to(:controller => "vend", :action => "customer_update", :format => :json)
      end
    end

    describe "customer_update_mq" do
      it "POST json" do
        { :post => "/vend/customer_update_mq" }.should route_to(:controller => "vend", :action => "customer_update_mq", :format => :json)
      end
      it "GET json" do
        { :get => "/vend/customer_update_mq" }.should_not route_to(:controller => "vend", :action => "customer_update_mq", :format => :json)
      end
    end

    describe "admin/vend" do
      it "GET html" do
        { :get => "/admin/ffcrm_vend" }.should route_to(:controller => "admin/ffcrm_vend", :action => "index", :format => :html)
      end
      it "PUT html" do
        { :put => "/admin/ffcrm_vend" }.should route_to(:controller => "admin/ffcrm_vend", :action => "update", :format => :html)
      end
    end

  end
end
