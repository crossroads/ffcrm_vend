module FfcrmVend
  class Engine < ::Rails::Engine

    # Tell Rails that when generating models, controllers for this engine to use RSpec and FactoryGirl, instead of the default of Test::Unit and fixtures
    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

  end
end
