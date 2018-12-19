# frozen_string_literal: true

source "https://rubygems.org"

gem "levenshtein-ffi", "~> 1.1.0", require: "levenshtein"
gem "nokogiri", "~> 1.9.1"
gem "prius", "~> 2.0"
gem "rufus-scheduler", "~> 3.5.2"
gem "sentry-raven", "~> 2.7.4", require: "sentry-raven-without-integrations"

# Transport
gem "curb", "~> 0.9.7" # HTTP transport library
gem "discordrb", "~> 3.3.0"
gem "songkick-transport", "~> 1.11.0"

group :development do
  gem "rake"

  gem "factory_bot", "~> 4.11.1"
  gem "rspec", "~> 3.8.0"
  gem "rubocop", "~> 0.61.1"
  gem "webmock", "~> 3.4.2"

  gem "pry-byebug"
end

group :test do
  # Used by CircleCI to collect test data
  gem "rspec_junit_formatter", "0.4.1"
end
