# frozen_string_literal: true
require "spec_helper"

RSpec.describe Tfl::IdResolver do
  subject { described_class.resolve(string) }

  context "with a similar string" do
    mappings = {
      # given => expected
      "bs" => "bus",
      "busz" => "bus",
      "cablecar" => "cable-car",
      "dnglway" => "cable-car",
      "hammmersmith" => "hammersmith-city",
      "donlon-overground" => "london-overground",
      "ldr" => "dlr",
      "picadily" => "piccadilly",
      "piccdilly" => "piccadilly",
      "tarm" => "tram"
    }

    mappings.each do |given, expected|
      context "that is #{given}" do
        let(:string) { given }

        it "resolves it to #{expected}" do
          is_expected.to eq(expected)
        end
      end
    end
  end

  context "with an existing alias" do
    let(:string) { "dangleway" }

    it "resolves it to a valid name" do
      is_expected.to eq("cable-car")
    end
  end

  context "with an invalid alias" do
    let(:string) { "invalid" }

    it "returns the original string" do
      is_expected.to eq("invalid")
    end
  end
end
