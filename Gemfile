# frozen_string_literal: true

source "https://rubygems.org"

gem "damerau-levenshtein", "~> 1.3.3"
gem "nokogiri", "~> 1.18.10"
gem "prius", "~> 6.0"
gem "rufus-scheduler", "~> 3.9.2"
gem "sentry-raven", "~> 3.1.2", require: "sentry-raven-without-integrations"

# Transport
gem "discordrb", "~> 3.4"

gem "httparty", "~> 0.23.2" # HTTP transport library
gem "songkick-transport", "~> 1.11.0"

# Required by httparty
gem "bigdecimal", "~> 3.2.3"

gem "prometheus-client", "~> 4.2.5"
gem "rack", "~> 3.2"
gem "rackup", "~> 2.2.1"
gem "webrick", "~> 1.9.1"

group :development do
  gem "rake"

  gem "factory_bot", "~> 6.5.5"
  gem "rspec", "~> 3.13.1"
  gem "rubocop", "~> 1.81.1"
  gem "rubocop-rspec", "~> 3.7.0"
  gem "webmock", "~> 3.25.1"

  gem "pry-byebug"
end

group :test do
  # Used by CircleCI to collect test data
  gem "rspec_junit_formatter", "0.6.0"
end
