# frozen_string_literal: true

source "https://rubygems.org"

gem "damerau-levenshtein", "~> 1.3.3"
gem "nokogiri", "~> 1.14.0"
gem "prius", "~> 5.0"
gem "rufus-scheduler", "~> 3.8.2"
gem "sentry-raven", "~> 3.1.2", require: "sentry-raven-without-integrations"

# Transport
gem "discordrb", "~> 3.4"

gem "httparty", "~> 0.21.0" # HTTP transport library
gem "songkick-transport", "~> 1.11.0"

# Required by httparty
gem "bigdecimal", "~> 3.1.3"

gem "prometheus-client", "~> 4.0.0"
gem "rack", "~> 3.0"
gem "rackup", "~> 0.2.3"
gem "webrick", "~> 1.7.0"

group :development do
  gem "rake"

  gem "factory_bot", "~> 6.2.1"
  gem "rspec", "~> 3.12.0"
  gem "rubocop", "~> 1.43.0"
  gem "rubocop-rspec", "~> 2.16.0"
  gem "webmock", "~> 3.18.1"

  gem "pry-byebug"
end

group :test do
  # Used by CircleCI to collect test data
  gem "rspec_junit_formatter", "0.6.0"
end
