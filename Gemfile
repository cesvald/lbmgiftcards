source 'http://rubygems.org'

ruby '2.0.0'

gem 'rails', '4.1.8'

gem 'pg'
gem 'state_machine'
gem 'schema_plus'

# Controller related
gem 'responders'

# Authentication and authorization
gem 'devise'
gem 'pundit'

# I18n
gem 'devise-i18n'
gem 'devise-i18n-views', github: 'mcasimir/devise-i18n-views'
gem 'rails-i18n', github: 'svenfuchs/rails-i18n', branch: 'master'

# Views and assets
gem 'foundation-rails'
gem 'slim'
gem 'slim-rails'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'simple_form'
gem 'rails-backbone'

# Other tools
gem 'has_scope'

group :test, :development do
  gem 'letter_opener'
  gem 'spring'
  gem 'better_errors'
  gem 'rspec-rails'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda'
  gem 'factory_girl_rails'
  gem 'capybara',   '2.2.0'
end

group :production do
  # Workers, forks and all that jazz
  gem 'unicorn'
  # Enabling Gzip on Heroku
  # If you don't use Heroku, please comment the line below.
  gem 'heroku-deflater', '>= 0.4.1'
  gem 'rails_12factor'
  gem 'rack-timeout'
end
