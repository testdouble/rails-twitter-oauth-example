source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "rails"
gem "sqlite3"
gem "puma"
gem "webpacker"

gem "bcrypt", "~> 3.1.7"

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem "bootsnap", ">= 1.4.4", require: false

group :development, :test do
  gem "pry-rails"
  gem "dotenv-rails"
end

group :development do
  gem "standard"
end

group :test do
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  gem "webdrivers"
end
