# frozen_string_literal: true
require "spec_helper"

RSpec.describe Bot::DiscordUtils do
  describe "#filter_mentions" do
    describe "when given an empty list of mentions" do
      it "returns the original argument list" do
        expect(described_class.filter_mentions(
                 "hello", "world", "lorem", "ipsum", mentions: []
        )).to eq(%w(hello world lorem ipsum))
      end

      context "with an empty list" do
        it "returns an empty list" do
          expect(described_class.filter_mentions(mentions: [])).to be_empty
        end
      end
    end

    describe "when given a list of mentions" do
      let(:mentions) do
        [
          instance_double(Discordrb::User, id: 123),
          instance_double(Discordrb::Channel, id: 456),
          instance_double(Discordrb::Role, id: 789),
          instance_double(Discordrb::User, id: 1234)
        ]
      end

      it "removes mentions" do
        args = %w(hello <@123> world <!@456> lorem <#789> ipsum <@&1234>)
        expect(described_class.filter_mentions(*args, mentions: mentions)).
          to eq(%w(hello world lorem ipsum))
      end

      context "with an empty list" do
        it "returns an empty list" do
          expect(described_class.filter_mentions(mentions: mentions)).to be_empty
        end
      end
    end
  end

  describe "#mention_of_self?" do
    let(:event) do
      double.tap do |event|
        allow(event).to receive_message_chain("bot.profile.id" => id)
      end
    end

    describe "when it is" do
      let(:id) { 1234 }
      it "returns true" do
        expect(described_class.mentions_of_self?(event, "<!@1234>")).to be true
      end
    end

    describe "when it isn't" do
      let(:id) { 123456 }
      it "returns false" do
        expect(described_class.mentions_of_self?(event, "<!@1234>")).to be false
      end
    end
  end
end
