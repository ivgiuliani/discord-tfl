# frozen_string_literal: true

source "https://rubygems.org"

gem "levenshtein-ffi", "~> 1.1.0", require: "levenshtein"
gem "nokogiri", "~> 1.7.2"
gem "prius", "~> 1.0"
gem "rufus-scheduler", "~> 3.4.2"
gem "sentry-raven", "~> 2.5.2", require: "sentry-raven-without-integrations"

# Transport
gem "curb", "~> 0.9.3" # HTTP transport library
gem "discordrb", "~> 3.2.1"
gem "songkick-transport", "~> 1.11.0"

group :development do
  gem "rake"

  gem "factory_girl", "~> 4.8.0"
  gem "rspec", "~> 3.6.0"
  gem "rubocop", "~> 0.49.1"
  gem "webmock", "~> 3.0.1"
end

group :test do
  # Used by CircleCI to collect test data
  gem "rspec_junit_formatter", "0.2.3"
end
