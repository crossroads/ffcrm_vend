#
# Ensure we have some settings for our tests
#

Rspec.configure do |config|

  config.before(:each) do
    user = FactoryGirl.create(:user)
    Setting[:ffcrm_vend] = {:vend_id => 'testvendid', :user_id => user.id, :sale_prefix => 'Test Sale'}
  end

end
