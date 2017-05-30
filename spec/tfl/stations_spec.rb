# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tfl::Stations do
  describe "#find" do
    subject(:find) { described_class.find(arg) }

    describe "when given an exact match" do
      let(:arg) { "Tottenham Court Road" }

      it "returns the expected station" do
        expect(find.display_name).to eq(arg)
      end
    end

    describe "when given a similar name" do
      let(:arg) { "Tottaham court road" }

      it "returns the expected station" do
        expect(find.display_name).to eq("Tottenham Court Road")
      end
    end

    describe "when given an alias" do
      let(:arg) { "king's cross" }

      it "returns the expected station" do
        expect(find.display_name).to eq("King's Cross St. Pancras")
      end

      context "and the station has multiple aliases defined" do
        let(:arg) { "shebu" }

        it "returns the expected station" do
          expect(find.display_name).to eq("Shepherd's Bush Central")
        end
      end

      context "that is not an exact match" do
        let(:arg) { "shebush" }

        it "returns the expected station" do
          expect(find.display_name).to eq("Shepherd's Bush Central")
        end
      end
    end

    describe "when given an invalid name" do
      INVALID = [
        "a",
        "aaa",
        "dlr",
        "zzz",
        "this station does not exist"
      ].freeze
      INVALID.each do |invalid|
        context "that is #{invalid}" do
          let(:arg) { invalid }

          it "returns nil" do
            expect(find).to be_nil
          end
        end
      end
    end
  end
end
