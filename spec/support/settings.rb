#
# Ensure we have some settings for our tests
#

RSpec.configure do |config|

  config.before(:each) do
    user = FactoryGirl.create(:user)
    Setting[:ffcrm_vend] = {:vend_id => 'testvendid', :user_id => user.id,
     :sale_prefix => 'Test Sale', :token => nil, :exclude_customers => ""}
  end

end
