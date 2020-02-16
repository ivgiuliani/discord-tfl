# frozen_string_literal: true

source "https://rubygems.org"

gem "damerau-levenshtein", "~> 1.3.2"
gem "nokogiri", "~> 1.10.8"
gem "prius", "~> 2.0"
gem "rufus-scheduler", "~> 3.6.0"
gem "sentry-raven", "~> 2.13.0", require: "sentry-raven-without-integrations"

# Transport
gem "discordrb", "~> 3.3.0"
gem "httparty", "~> 0.17.3" # HTTP transport library
gem "songkick-transport", "~> 1.11.0"

# Required by httparty
gem "bigdecimal", "~> 2.0.0"

group :development do
  gem "rake"

  gem "factory_bot", "~> 5.1.1"
  gem "rspec", "~> 3.9.0"
  gem "rubocop", "~> 0.79.0"
  gem "rubocop-rspec", "~> 1.38.1"
  gem "webmock", "~> 3.8.2"

  gem "pry-byebug"
end

group :test do
  # Used by CircleCI to collect test data
  gem "rspec_junit_formatter", "0.4.1"
end
