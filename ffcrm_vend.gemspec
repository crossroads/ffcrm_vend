$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ffcrm_vend/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ffcrm_vend"
  s.version     = FfcrmVend::VERSION
  s.authors     = ["Ben Tillman"]
  s.email       = ["ben.tillman@gmail.com"]
  s.homepage    = "http://fatfreecrm.com"
  s.summary     = "Integration to vendhq.com"
  s.description = "Integration to vendhq.com provides webhook for register_sale"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.12"
  
  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails', '~> 2.0'
  s.add_development_dependency 'capybara', '~> 1.1.2'
  s.add_development_dependency 'combustion', '~> 0.3.1'
end