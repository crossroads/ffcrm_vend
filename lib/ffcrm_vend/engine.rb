module FfcrmVend
  class Engine < ::Rails::Engine

    config.to_prepare do
      tab_urls = FatFreeCRM::Tabs.admin.map{|tab| tab[:url]}.map{|url| url[:controller]}
      unless tab_urls.include? 'admin/ffcrm_vend'
        FatFreeCRM::Tabs.admin << {url: { controller: "admin/ffcrm_vend" }, text: "Vend", icon: 'fa-usd'}
      end
    end

    # Tell Rails that when generating models, controllers for this engine to use RSpec and FactoryBot, instead of the default of Test::Unit and fixtures
    config.generators do |g|
      g.test_framework      :rspec,       fixture: false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer :append_migrations do |app|
      unless "#{root}/spec/dummy" == app.root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

  end
end
