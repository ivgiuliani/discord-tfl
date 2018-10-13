# frozen_string_literal: true

require "spec_helper"

RSpec.describe Bot::Config do
  let(:instance) { described_class.new }

  describe "when loading a config file" do
    subject(:config_load) do
      instance.load_config(fixture_path("sample_config", type: "yml"))
    end

    describe "override the default settings" do
      mappings = {
        # method => [default, expected]
        prefix: [Bot::DefaultConfig::PREFIX, "@"],
        username: [Bot::DefaultConfig::USERNAME, "username123"],
        game: [Bot::DefaultConfig::GAME, "The Game"],
        pr_announce_channels_ids: [Bot::DefaultConfig::PR_ANNOUNCE_CHANNELS_IDS, [1, 2]],
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

    it "marks the configuration as loaded after loading it" do
      expect(instance.config_loaded).to be false
      config_load
      expect(instance.config_loaded).to be true
    end
  end

  describe "when not loading a config file" do
    mappings = {
      # method => default,
      prefix: Bot::DefaultConfig::PREFIX,
      username: Bot::DefaultConfig::USERNAME,
      game: Bot::DefaultConfig::GAME,
      pr_announce_channels_ids: Bot::DefaultConfig::PR_ANNOUNCE_CHANNELS_IDS,
    }

    mappings.each do |method, default|
      context "for #{method}" do
        it "returns the default value" do
          expect(instance.method(method.to_sym).call).to eq(default)
        end
      end
    end
  end
end
