# frozen_string_literal: true

source "https://rubygems.org"

gem "damerau-levenshtein", "~> 1.3.3"
gem "nokogiri", "~> 1.13.1"
gem "prius", "~> 2.0"
gem "rufus-scheduler", "~> 3.8.0"
gem "sentry-raven", "~> 3.1.2", require: "sentry-raven-without-integrations"

# Transport
gem "discordrb", "~> 3.4"

gem "httparty", "~> 0.20.0" # HTTP transport library
gem "songkick-transport", "~> 1.11.0"

# Required by httparty
gem "bigdecimal", "~> 3.1.1"

gem "prometheus-client", "~> 2.1.0"
gem "rack", "~> 2.2"
gem "webrick", "~> 1.7.0"

group :development do
  gem "rake"

  gem "factory_bot", "~> 6.2.0"
  gem "rspec", "~> 3.10.0"
  gem "rubocop", "~> 1.25.0"
  gem "rubocop-rspec", "~> 2.7.0"
  gem "webmock", "~> 3.14.0"

  gem "pry-byebug"
end

group :test do
  # Used by CircleCI to collect test data
  gem "rspec_junit_formatter", "0.5.1"
end
