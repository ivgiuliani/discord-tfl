# frozen_string_literal: true

require "spec_helper"

RSpec.describe Bot::DiscordUtils do
  describe "#filter_mentions" do
    describe "when given an empty list of mentions" do
      it "returns the original argument list" do
        expect(described_class.filter_mentions(
                 "hello", "world", "lorem", "ipsum", mentions: []
               )).to eq(%w[hello world lorem ipsum])
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
        args = %w[hello <@123> world <!@456> lorem <#789> ipsum <@&1234>]
        expect(described_class.filter_mentions(*args, mentions: mentions)).
          to eq(%w[hello world lorem ipsum])
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

  describe "emoji" do
    describe "#emoji?" do
      context "with a valid emoji" do
        it "returns true" do
          expect(described_class::Emoji.emoji?(":scream:")).to be true
        end

        context "that is uppercase" do
          it "returns false" do
            expect(described_class::Emoji.emoji?(":SCREAM:")).to be false
          end
        end
      end

      context "with a normal word" do
        it "returns false" do
          expect(described_class::Emoji.emoji?("-1")).to be false
          expect(described_class::Emoji.emoji?("+1")).to be false
          expect(described_class::Emoji.emoji?("scream")).to be false
          expect(described_class::Emoji.emoji?(":scream")).to be false
          expect(described_class::Emoji.emoji?("scream:")).to be false
        end
      end

      context "with an empty string" do
        it "returns false" do
          expect(described_class::Emoji.emoji?("")).to be false
        end
      end

      context "with the preset emojis" do
        described_class::Emoji.constants.each do |emoji_c|
          emoji = described_class::Emoji.const_get(emoji_c)

          context "that is #{emoji}" do
            it "retuns true" do
              expect(described_class::Emoji.emoji?(emoji)).to be true
            end
          end
        end
      end
    end
  end
end
