source "http://rubygems.org"

# For heroku
ruby "2.0.0"

## Bundle rails:
gem "rails", "3.2.13"
gem "pg"
gem "thin"

# I18n
gem "rails-i18n"

# Controller improvements 
gem "inherited_resources"

group :assets do
  gem "sass",         ">= 3.2.3"
  gem "sass-rails",   ">= 3.2.6"
  gem "compass-rails"
  gem "coffee-rails", "~> 3.2.1"
  gem "semantic-mixins", "0.2.0"
  gem "uglifier", ">= 1.0.3"
  gem "zurb-foundation", "~> 4.0.0"
end

gem "american_date"
gem "authlogic"#, "3.2.0"
# gem "asset_sync"
# gem "aws-sdk"
gem "bluecloth",     "~> 2.1.0"
gem "cancan", "~> 1.6.8"
gem "chronic"
gem "dalli", "~> 1.0.2"

gem "dynamic_form"
gem "friendly_id", "~> 3.3"
gem "haml",  ">= 3.0.13"#, ">= 3.0.4"#, "2.2.21"#,
gem "high_voltage"
gem "jquery-rails"
gem "json", "~>1.7.7"

gem "simple_form"

gem "nested_set", "~> 1.7.0"
gem "nifty-generators", git: "git://github.com/drhenner/nifty-generators.git"
gem "nokogiri", "~> 1.5.0"
# gem "paperclip", "~> 3.0"
gem "prawn", "~> 0.12.0"

gem "rails3-generators", git: "https://github.com/neocoin/rails3-generators.git"
gem "rails_config"
# gem "rmagick",    require: "RMagick"

# Payment
gem "activemerchant", "~> 1.29.3"#, lib: "active_merchant"
# gem "paypal-express"

gem "rake", "~> 0.9.2"
gem "state_machine", "~> 1.1.2"
#gem "sunspot_solr"
#gem "sunspot_rails", "~> 1.3.0rc"
gem "will_paginate", "~> 3.0.4"

gem "flickraw-cached"

#gem "memcache-client", "~> 1.8.5"

# Template language
gem "slim"
gem "slim-rails"

group :development do
  gem "awesome_print"
  gem "annotate", git: "git://github.com/ctran/annotate_models.git"
  gem "quiet_assets"
  gem "autotest-rails-pure"

  gem "rails-erd"
  gem "debugger"

  # YARD AND REDCLOTH are for generating yardocs
  gem "yard"
  gem "RedCloth"

  gem "better_errors"
  gem "binding_of_caller"
end
group :test, :development do
  gem "capybara", "~> 1.1"#, git: "git://github.com/jnicklas/capybara.git"
  gem "launchy"
  gem "database_cleaner"
end

group :test do
  gem "factory_girl", "~> 3.3.0"
  gem "factory_girl_rails", "~> 3.3.0"
  gem "mocha", "~> 0.10.0", require: false
  gem "rspec-rails-mocha"
  gem "rspec-rails", "~> 2.12.2"

  gem "email_spec"

  gem "faker"
  gem "autotest", "~> 4.4.6"
  gem "autotest-rails-pure"

  gem "autotest-growl"
  #gem "redgreen"
  gem "ZenTest"
end
