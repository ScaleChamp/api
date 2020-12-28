source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Field Encryption
gem 'lockbox'
# Authorization Toolkit
gem 'pundit', '~> 2.1.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.2.1'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3.4'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.3.5'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.0', require: false
# RabbitMQ client
gem 'bunny', '~> 2.16.1'
# Modern HTTP client
gem 'httparty', '~> 0.18.1'
# Pusher client
gem 'pusher', '~> 1.3.3'
# ActiveModel JSON serializer
gem "active_model_serializers", '~> 0.10.10'
# Telegram bot
gem 'telegram-bot-ruby', '~> 0.12.0'
# Pagination
gem 'will_paginate', '~> 3.3.0'
# API pagination
gem 'api-pagination', '~> 4.8.2'
# Encryption
gem 'bcrypt', '~> 3.1.16'
# AWS SDK
gem 'aws-sdk-s3', '~> 1'
# AWS IAM
gem 'aws-sdk-iam', '~> 1'
# Rate Limiting middleware
gem 'rack-attack', '~> 6.3.1'
# CORS
gem 'rack-cors', '~> 1.1.1'
# 2FA
gem 'active_model_otp', '~> 2.0.1'
# Omniauth
gem 'omniauth', '~> 1.9.1'
# Omniauth github
gem 'omniauth-github', github: 'omniauth/omniauth-github', branch: 'master'
# Omniauth google
gem 'omniauth-google-oauth2', '~> 0.8.0'
# PDF generator
gem 'wicked_pdf', '~> 2.1.0'
# PDF generator library
gem 'wkhtmltopdf-binary', '~> 0.12.6.3'
# recaptcha
gem 'recaptcha', github: 'ambethia/recaptcha'
# Handling of poweroff tasks via RabbitMQ
gem 'sneakers', '~> 2.12.0'
# Deployment
group :development do
  gem 'capistrano', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'listen', '>= 3.0.5', '< 3.2'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
