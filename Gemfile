# frozen_string_literal: true

source "https://rubygems.org"

gem "levenshtein-ffi", "~> 1.1.0", require: "levenshtein"
gem "nokogiri", "~> 1.8.4"
gem "prius", "~> 2.0"
gem "rufus-scheduler", "~> 3.5.1"
gem "sentry-raven", "~> 2.7.4", require: "sentry-raven-without-integrations"

# Transport
gem "curb", "~> 0.9.6" # HTTP transport library
gem "discordrb", "~> 3.2.1"
gem "songkick-transport", "~> 1.11.0"

group :development do
  gem "rake"

  gem "factory_bot", "~> 4.10.0"
  gem "rspec", "~> 3.7.0"
  gem "rubocop", "~> 0.58.2"
  gem "webmock", "~> 3.4.2"

  gem "pry-byebug"
end

group :test do
  # Used by CircleCI to collect test data
  gem "rspec_junit_formatter", "0.4.1"
end
