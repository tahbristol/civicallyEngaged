source 'https://rubygems.org'

gem 'sinatra'
gem 'rake'
gem 'nokogiri'
gem 'twilio-ruby'
gem 'activerecord', require: 'active_record'
gem 'sinatra-activerecord', require: 'sinatra/activerecord'
gem 'bcrypt'
gem 'sinatra-contrib', require: 'sinatra/reloader'
gem 'require_all'

gem 'rack-flash3', require: 'rack-flash'
gem 'sinatra-flash'

gem 'thin'
gem 'shotgun'
gem 'tux'
gem 'pony'
group :production do
  gem 'pg'
  
end

group :development do
  gem 'dotenv'
  gem 'pry'
  gem 'sqlite3'
end
group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'rack-test'
  gem 'database_cleaner', git: 'https://github.com/bmabey/database_cleaner.git'
end
