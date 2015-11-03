source 'https://rubygems.org'

ruby '2.2.3'

gem 'rails', '4.2.3'
gem 'rails-api'
gem 'sqlite3'
gem 'active_model_serializers', github: 'rails-api/active_model_serializers'

gem 'warden'
gem 'bcrypt', '~> 3.1.7'
gem 'has_secure_token'

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'codeclimate-test-reporter', require: nil
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
end
