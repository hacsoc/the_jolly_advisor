source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.1'

gem 'coffee-rails', '~> 4.1.0'
gem 'fullcalendar-rails'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'less-rails'
gem 'momentjs-rails'
gem 'nokogiri'
gem 'pg'
gem 'rails'
gem 'rollbar'
gem 'rubycas-client', github: 'rubycas/rubycas-client'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'smarter_csv', require: false
gem 'therubyracer'
gem 'turbolinks'
gem 'twitter-bootstrap-rails', '~> 3.0'
gem 'uglifier', '>= 1.3.0'

group :development do
  gem 'guard'
  gem 'guard-cucumber'
  gem 'guard-rspec'
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  gem 'byebug'
  gem 'coveralls', require: false
  gem 'factory_girl_rails', require: false
  gem 'pry-rails'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'watir'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'forgery'
  gem 'rack_session_access'
  gem 'rails-controller-testing'
  gem 'rake'
end
