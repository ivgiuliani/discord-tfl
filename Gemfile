# frozen_string_literal: true

source "https://rubygems.org"

gem "damerau-levenshtein", "~> 1.3.3"
gem "nokogiri", "~> 1.15.3"
gem "prius", "~> 5.0"
gem "rufus-scheduler", "~> 3.9.1"
gem "sentry-raven", "~> 3.1.2", require: "sentry-raven-without-integrations"

# Transport
gem "discordrb", "~> 3.4"

gem "httparty", "~> 0.21.0" # HTTP transport library
gem "songkick-transport", "~> 1.11.0"

# Required by httparty
gem "bigdecimal", "~> 3.1.4"

gem "prometheus-client", "~> 4.2.1"
gem "rack", "~> 3.0"
gem "rackup", "~> 2.1.0"
gem "webrick", "~> 1.8.1"

group :development do
  gem "rake"

  gem "factory_bot", "~> 6.2.1"
  gem "rspec", "~> 3.12.0"
  gem "rubocop", "~> 1.55.1"
  gem "rubocop-rspec", "~> 2.23.0"
  gem "webmock", "~> 3.18.1"

  gem "pry-byebug"
end

group :test do
  # Used by CircleCI to collect test data
  gem "rspec_junit_formatter", "0.6.0"
end
