# frozen_string_literal: true

source "https://rubygems.org"

gem "damerau-levenshtein", "~> 1.3.3"
gem "nokogiri", "~> 1.18.3"
gem "prius", "~> 6.0"
gem "rufus-scheduler", "~> 3.9.2"
gem "sentry-raven", "~> 3.1.2", require: "sentry-raven-without-integrations"

# Transport
gem "discordrb", "~> 3.4"

gem "httparty", "~> 0.22.0" # HTTP transport library
gem "songkick-transport", "~> 1.11.0"

# Required by httparty
gem "bigdecimal", "~> 3.1.9"

gem "prometheus-client", "~> 4.2.4"
gem "rack", "~> 3.1"
gem "rackup", "~> 2.2.1"
gem "webrick", "~> 1.9.1"

group :development do
  gem "rake"

  gem "factory_bot", "~> 6.5.1"
  gem "rspec", "~> 3.13.0"
  gem "rubocop", "~> 1.71.2"
  gem "rubocop-rspec", "~> 3.4.0"
  gem "webmock", "~> 3.25.0"

  gem "pry-byebug"
end

group :test do
  # Used by CircleCI to collect test data
  gem "rspec_junit_formatter", "0.6.0"
end
