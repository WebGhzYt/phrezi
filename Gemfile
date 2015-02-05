source 'http://rubygems.org'
source 'http://rails-assets.org'

#ruby '2.1.1'
#gem 'libv8 -v 3.11.8.17 -- --with-system-v8'
gem 'bourbon'
#gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'delayed_job', github: 'collectiveidea/delayed_job'
gem 'delayed_job_active_record', github: 'abdulsattar/delayed_job_active_record', branch: 'patch-1'
gem 'email_validator'
gem 'flutie'
gem 'high_voltage'
gem 'jquery-rails'
gem 'neat'
gem 'pg', '~> 0.18.1'

gem 'rufus-scheduler'
gem 'rack-timeout'
gem 'rails', '~> 4.1.0'
gem 'recipient_interceptor'
gem 'sass-rails', github: 'rails/sass-rails'
gem 'simple_form'
gem 'country_select'
gem 'title'
gem 'uglifier'
# gem 'unicorn'
gem 'sprockets'#, '2.11.0'
gem 'rails-assets-underscore'
gem 'rails-assets-bootstrap-datepicker'
gem 'momentjs-rails', '>= 2.5.0'
gem 'bootstrap3-datetimepicker-rails', '~> 3.0.0.2'
gem 'pundit'
gem 'active_model_serializers'
gem 'gon'
gem 'slim-rails'
gem 'faker'
gem 'geocoder'
gem 'geokit-rails'
# gem 'turbolinks'
# gem 'pjax_rails'
gem "paperclip", "~> 4.1"
gem 'bootstrap-timepicker-rails'
gem 'time_diff'

# for AWS S3
gem 'aws-sdk'
gem "figaro"

#gem 'time_difference'

#authentication / authorization
gem 'devise'
gem 'opro'
#for validations
gem 'jquery-validation-rails'
gem 'jquery-ui-rails'
gem 'remotipart', '~> 1.2'
#for countries helper
gem 'carmen-rails', '~> 1.0.0'
#devise extension for invitation
gem 'devise_invitable'
group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'foreman'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'quiet_assets'
end

group :development, :test, :staging do
  gem 'factory_girl_rails'
end

group :development, :test do
  gem 'dotenv-rails'
  # gem 'pry-rails'
  gem 'rspec-rails'
  gem 'mailcatcher'
end

group :test do
  gem 'database_cleaner'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'webmock'
  gem 'email_spec'
  gem 'cucumber-rails', require: false
  gem 'capybara'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'guard-cucumber'
end

group :staging, :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
end

#gem 'therubyracer'
gem 'execjs'
gem 'therubyracer', :platform => :ruby
#gem 'therubyracer', '~> 0.12.1'
#gem 'libv8', '~> 3.16.14.7'

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'bcrypt-ruby', '~> 3.1.5'
gem 'timezone'
gem 'jquery-datatables-rails', git: 'git://github.com/rweng/jquery-datatables-rails.git'
