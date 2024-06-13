# frozen_string_literal: true

source "https://rubygems.org"

gem "damerau-levenshtein", "~> 1.3.3"
gem "nokogiri", "~> 1.16.5"
gem "prius", "~> 6.0"
gem "rufus-scheduler", "~> 3.9.1"
gem "sentry-raven", "~> 3.1.2", require: "sentry-raven-without-integrations"

# Transport
gem "discordrb", "~> 3.4"

gem "httparty", "~> 0.22.0" # HTTP transport library
gem "songkick-transport", "~> 1.11.0"

# Required by httparty
gem "bigdecimal", "~> 3.1.8"

gem "prometheus-client", "~> 4.2.2"
gem "rack", "~> 3.1"
gem "rackup", "~> 2.1.0"
gem "webrick", "~> 1.8.1"

group :development do
  gem "rake"

  gem "factory_bot", "~> 6.4.6"
  gem "rspec", "~> 3.13.0"
  gem "rubocop", "~> 1.63.5"
  gem "rubocop-rspec", "~> 3.0.1"
  gem "webmock", "~> 3.23.0"

  gem "pry-byebug"
end

group :test do
  # Used by CircleCI to collect test data
  gem "rspec_junit_formatter", "0.6.0"
end
