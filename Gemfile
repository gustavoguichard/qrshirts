source 'http://rubygems.org'

## Bundle rails:
gem 'rails', '3.2.11'
gem 'pg'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'compass-rails'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'semantic-mixins'
  gem 'uglifier', '>= 1.0.3'
end

gem "activemerchant", '~> 1.29.3'#, :lib => 'active_merchant'
gem "american_date"
gem 'authlogic'#, "3.2.0"
gem "asset_sync"
gem 'aws-sdk'
gem 'bluecloth',     '~> 2.1.0'
gem 'cancan', '~> 1.6.8'
gem 'compass', '~> 0.12.0'
gem 'compass-rails'
#  gem 'dalli', '~> 1.0.2'

gem 'dynamic_form'
gem "friendly_id", "~> 3.3"
gem 'haml',  ">= 3.0.13"#, ">= 3.0.4"#, "2.2.21"#,
gem "jquery-rails"
gem 'json', '~>1.7.7'

gem 'nested_set', '~> 1.7.0'
#gem "nifty-generators", :git => 'git://github.com/drhenner/nifty-generators.git'
gem 'nokogiri', '~> 1.5.0'
gem 'paperclip', '~> 3.0'
gem 'prawn', '~> 0.12.0'

gem "rails3-generators", :git => "https://github.com/neocoin/rails3-generators.git"
gem "rails_config"
gem 'rmagick',    :require => 'RMagick'

gem 'rake', '~> 0.9.2'
gem 'state_machine', '~> 1.1.2'
#gem 'sunspot_solr'
#gem 'sunspot_rails', '~> 1.3.0rc'
gem 'will_paginate', '~> 3.0.4'

#gem 'memcache-client', '~> 1.8.5'

# Template language
gem 'slim'
gem 'slim-rails'

group :development do
  gem 'awesome_print'
  #gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'quiet_assets'
  gem "autotest-rails-pure"

  gem "rails-erd"
  gem "debugger"

  # YARD AND REDCLOTH are for generating yardocs
  gem 'yard'
  gem 'RedCloth'
end
group :test, :development do
  gem "rspec-rails", "~> 2.8.0"
  gem 'capybara', "~> 1.1"#, :git => 'git://github.com/jnicklas/capybara.git'
  gem 'launchy'
  gem 'database_cleaner'
end

group :test do
  gem 'factory_girl', "~> 3.3.0"
  gem 'factory_girl_rails', "~> 3.3.0"
  gem 'mocha', '~> 0.10.0', :require => false
  gem 'rspec-rails-mocha'
  gem "rspec",        "~> 2.8.0"

  gem "rspec-core",         "~> 2.8.0"
  gem "rspec-expectations", "~> 2.8.0"
  gem "rspec-mocks",        "~> 2.8.0"
  gem 'email_spec'

  gem "faker"
  gem "autotest", '~> 4.4.6'
  gem "autotest-rails-pure"

  gem "autotest-growl"
  #gem "redgreen"
  gem "ZenTest", '4.6.2'
end
