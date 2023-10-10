$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ffcrm_vend/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ffcrm_vend"
  s.version     = FfcrmVend::VERSION
  s.authors     = ["Ben Tillman", "Steve Kenworthy"]
  s.email       = ["ben.tillman@gmail.com", "steveyken@gmail.com"]
  s.homepage    = "http://www.fatfreecrm.com"
  s.summary     = "Integration to vendhq.com"
  s.description = "Integration to vendhq.com provides webhook for register_sale"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails"
  s.add_dependency "fat_free_crm", "~> 0.21.0"
  s.add_dependency 'ransack', '< 4'
  s.add_dependency 'ransack_ui'

  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'listen'
end
