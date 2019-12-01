# frozen_string_literal: true

source "https://rubygems.org"

gem "levenshtein-ffi", "~> 1.1.0", require: "levenshtein"
gem "nokogiri", "~> 1.10.5"
gem "prius", "~> 2.0"
gem "rufus-scheduler", "~> 3.6.0"
gem "sentry-raven", "~> 2.12.3", require: "sentry-raven-without-integrations"

# Transport
gem "discordrb", "~> 3.3.0"
gem "httparty", "~> 0.17.1" # HTTP transport library
gem "songkick-transport", "~> 1.11.0"

# Required by httparty
gem "bigdecimal", "~> 1.4.4"

group :development do
  gem "rake"

  gem "factory_bot", "~> 5.1.1"
  gem "rspec", "~> 3.9.0"
  gem "rubocop", "~> 0.77.0"
  gem "rubocop-rspec", "~> 1.37.0"
  gem "webmock", "~> 3.7.6"

  gem "pry-byebug"
end

group :test do
  # Used by CircleCI to collect test data
  gem "rspec_junit_formatter", "0.4.1"
end
