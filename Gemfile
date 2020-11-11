# frozen_string_literal: true

source "https://rubygems.org"

gem "damerau-levenshtein", "~> 1.3.3"
gem "nokogiri", "~> 1.10.10"
gem "prius", "~> 2.0"
gem "rufus-scheduler", "~> 3.6.0"
gem "sentry-raven", "~> 3.1.1", require: "sentry-raven-without-integrations"

# Transport
gem "discordrb", "~> 3.3.0"
gem "httparty", "~> 0.18.1" # HTTP transport library
gem "songkick-transport", "~> 1.11.0"

# Required by httparty
gem "bigdecimal", "~> 2.0.0"

gem "prometheus-client", "~> 2.1.0"
gem "rack", "~> 2.2"

group :development do
  gem "rake"

  gem "factory_bot", "~> 6.1.0"
  gem "rspec", "~> 3.10.0"
  gem "rubocop", "~> 1.2.0"
  gem "rubocop-rspec", "~> 2.0.0"
  gem "webmock", "~> 3.9.5"

  gem "pry-byebug"
end

group :test do
  # Used by CircleCI to collect test data
  gem "rspec_junit_formatter", "0.4.1"
end
