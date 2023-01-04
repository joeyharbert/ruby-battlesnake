# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'sinatra'
gem 'battlesnake', "~> 0.1.4"

group :development, :test do
  gem 'dotenv'

  gem "rspec"

  gem "guard"
  gem "guard-rspec", require: false
end
