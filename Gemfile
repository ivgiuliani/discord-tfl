source 'https://rubygems.org'

gem 'prius', '~> 1.0'
gem 'levenshtein-ffi', '~> 1.1.0', :require => 'levenshtein'
gem 'nokogiri', '~> 1.7.0.1'
gem 'rufus-scheduler', '~> 3.4.0'
gem 'sentry-raven', '~> 2.3.1', require: 'sentry-raven-without-integrations'

# Transport
gem 'curb', '~> 0.9.3' # HTTP transport library
gem 'songkick-transport', '~> 1.11.0'
gem 'discordrb', '~> 3.2.0.1'

group :development do
  gem 'rake'

  gem 'rspec', '~> 3.6.0'
  gem 'factory_girl', '~> 4.8.0'
  gem 'rubocop', '~> 0.47.1'
  gem 'webmock', '~> 2.3.2'
end

group :test do
  # Used by CircleCI to collect test data
  gem 'rspec_junit_formatter', '0.2.3'
end

