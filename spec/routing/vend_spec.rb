require 'rails_helper'

describe 'VendController', type: :routing do

  describe "routing" do

    describe "register_sale" do
      it "POST json" do
        expect(:post => "/vend/register_sale.json").to route_to(controller: "vend", action: "register_sale", format: "json")
      end
      it "GET json" do
        expect(:get => "/vend/register_sale.json").not_to be_routable
      end
    end

    describe "register_sale_mq" do
      it "POST json" do
        expect(:post => "/vend/register_sale_mq.json").to route_to(:controller => "vend", :action => "register_sale_mq", :format => "json")
      end
      it "GET json" do
        expect(:get => "/vend/register_sale_mq.json").not_to be_routable
      end
    end

    describe "customer_update" do
      it "POST json" do
        expect(:post => "/vend/customer_update.json").to route_to(:controller => "vend", :action => "customer_update", :format => "json")
      end
      it "GET json" do
        expect(:get => "/vend/customer_update.json").not_to be_routable
      end
    end

    describe "customer_update_mq" do
      it "POST json" do
        expect(:post => "/vend/customer_update_mq.json").to route_to(:controller => "vend", :action => "customer_update_mq", :format => "json")
      end
      it "GET json" do
        expect(:get => "/vend/customer_update_mq.json").not_to be_routable
      end
    end

    describe "admin/vend" do
      it "GET html" do
        expect(:get => "/admin/ffcrm_vend").to route_to(:controller => "admin/ffcrm_vend", :action => "index")
      end
      it "PUT html" do
        expect(:put => "/admin/ffcrm_vend").to route_to(:controller => "admin/ffcrm_vend", :action => "update")
      end
    end

  end
end
