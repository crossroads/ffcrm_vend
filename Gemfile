source "http://rubygems.org"

gemspec

gem "fat_free_crm", path: "/home/steve/code/ffcrm/0.21/fat_free_crm"
gem 'responds_to_parent', git: 'https://github.com/CloCkWeRX/responds_to_parent.git'#, branch: 'patch-2' # Temporarily pointed at git until https://github.com/zendesk/responds_to_parent/pull/7 is released
gem 'acts_as_commentable', git: 'https://github.com/fatfreecrm/acts_as_commentable.git'

# jquery-rails is used by the dummy application
gem "jquery-rails"
gem "factory_bot_rails"
gem "byebug", group: [:development, :test] unless ENV["CI"]
