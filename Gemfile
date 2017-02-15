source 'https://rubygems.org'

gem 'rails', '~> 4.2.6'

# Maestrano Enterprise Engine
# Bundle edge Mnoe instead:

# TODO: remove ref - impac-angular#v1.5.0-rc2 requires master before renamed widget_category
gem 'mno-enterprise', git: 'https://github.com/maestrano/mno-enterprise', ref: '130afff7cac0aa21fbf9692f3cdc450963a2a06a'
# Use local mnoe
# gem 'mno-enterprise', path: '../mno-enterprise'

# Transactional emails
gem 'sparkpost', '~> 0.1.4'

# Use puma as the app server
gem 'puma'


# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Ops gems
group :uat, :production do
  gem 'newrelic_rpm'
  gem 'rails_stdout_logging' # For Nex! logs
end

# CI gems
group :development do
  # Security audits
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false

  # Style check
  gem 'rubocop', '~> 0.39', require: false
  gem 'rubocop-rspec', require: false
end

group :development, :test do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'

  # Code coverage
  gem 'simplecov'
end
