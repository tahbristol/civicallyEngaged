source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'nokogiri'
gem 'twilio-ruby'
gem 'activerecord', :require => 'active_record'
gem 'sinatra-activerecord', :require => 'sinatra/activerecord'
gem 'bcrypt'
gem 'sinatra-contrib', :require => 'sinatra/reloader'
gem 'require_all'
gem 'twilio-ruby'
gem 'rack-flash3', :require => 'rack-flash'
gem 'sinatra-flash'
gem 'dotenv', groups: [:development, :test]
gem 'thin'
gem 'shotgun'
gem 'tux'

group :production do
gem 'pg'
gem 'pony'
end

group :development do

  gem 'pry'
gem 'sqlite3'

end
group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'rack-test'
  gem 'database_cleaner', git: 'https://github.com/bmabey/database_cleaner.git'


end
