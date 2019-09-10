# frozen_string_literal: true

source "https://rubygems.org"

gem "levenshtein-ffi", "~> 1.1.0", require: "levenshtein"
gem "nokogiri", "~> 1.10.4"
gem "prius", "~> 2.0"
gem "rufus-scheduler", "~> 3.6.0"
gem "sentry-raven", "~> 2.11.1", require: "sentry-raven-without-integrations"

# Transport
gem "curb", "~> 0.9.10" # HTTP transport library
gem "discordrb", "~> 3.3.0"
gem "songkick-transport", "~> 1.11.0"

group :development do
  gem "rake"

  gem "factory_bot", "~> 5.0.2"
  gem "rspec", "~> 3.8.0"
  gem "rubocop", "~> 0.74.0"
  gem "rubocop-rspec", "~> 1.35.0"
  gem "webmock", "~> 3.7.0"

  gem "pry-byebug"
end

group :test do
  # Used by CircleCI to collect test data
  gem "rspec_junit_formatter", "0.4.1"
end
