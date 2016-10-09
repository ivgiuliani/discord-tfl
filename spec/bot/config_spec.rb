# frozen_string_literal: true
require "spec_helper"

RSpec.describe Bot::Config do
  context "when loading a config file" do
    let(:instance) do
      klass = Class.new
      klass.extend(Bot::Config)
      klass
    end

    subject(:config_load) do
      instance.load_config(fixture_path("sample_config", type: "yml"))
    end

    describe "override the default settings" do
      mappings = {
        # method => [default, expected]
        cfg_prefix: [Bot::Config::Default::PREFIX, "@"],
        cfg_username: [Bot::Config::Default::USERNAME, "username123"]
      }

      mappings.each do |method, values|
        context "for #{method}" do
          let(:default) { values[0] }
          let(:expected) { values[1] }

          it "changes its value" do
            expect { config_load }.to change { instance.method(method.to_sym).call }.
              from(default).to(expected)
          end
        end
      end
    end
  end
end
