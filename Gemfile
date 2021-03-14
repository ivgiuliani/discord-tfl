# frozen_string_literal: true

source "https://rubygems.org"

gem "damerau-levenshtein", "~> 1.3.3"
gem "nokogiri", "~> 1.11.2"
gem "prius", "~> 2.0"
gem "rufus-scheduler", "~> 3.7.0"
gem "sentry-raven", "~> 3.1.1", require: "sentry-raven-without-integrations"

# Transport

# Temporary fix:
# this branch includes a fix against accessing an unpopulated field when
# accessing uncached users, it can be removed once that fix gets released.
# gem "discordrb", "~> 3.4.2"
gem "discordrb",
    github: "swarley/discordrb-1",
    branch: "presence-fixup"

gem "httparty", "~> 0.18.1" # HTTP transport library
gem "songkick-transport", "~> 1.11.0"

# Required by httparty
gem "bigdecimal", "~> 3.0.0"

gem "prometheus-client", "~> 2.1.0"
gem "rack", "~> 2.2"
gem "webrick", "~> 1.7.0"

group :development do
  gem "rake"

  gem "factory_bot", "~> 6.1.0"
  gem "rspec", "~> 3.10.0"
  gem "rubocop", "~> 1.11.0"
  gem "rubocop-rspec", "~> 2.2.0"
  gem "webmock", "~> 3.12.1"

  gem "pry-byebug"
end

group :test do
  # Used by CircleCI to collect test data
  gem "rspec_junit_formatter", "0.4.1"
end
