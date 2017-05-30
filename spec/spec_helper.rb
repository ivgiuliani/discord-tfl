# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../../app", __FILE__)

ENV["DISCORD_CLIENT_ID"] = "12345678901234567"
ENV["DISCORD_TOKEN"] = "t0k3nt0k3nt0k3nt0k3nt0k3n.1234hrx0rz1234token"
ENV["TFL_APPLICATION_ID"] = "tfl-application-id"
ENV["TFL_APPLICATION_KEY"] = "tfl-application-key"

require "factory_girl"

require "webmock/rspec"
WebMock.disable_net_connect!(allow_localhost: true)

require "tflbot"

def fixture_path(fixture_name, type: "json")
  dir = "#{File.dirname(__FILE__)}/fixtures"
  File.join(dir, "#{fixture_name}.#{type}")
end

def load_fixture(fixture_name, type: "json")
  File.read(fixture_path(fixture_name, type: type))
end

def load_fixture_obj(fixture_name)
  JSON.parse(load_fixture(fixture_name))
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) { FactoryGirl.find_definitions }

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
