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
      "donlon-overground" => "overground",
      "ovalground" => "overground",
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
    Tfl::IdResolver::ALIASES.each do |given_alias, expected|
      context "that is #{given_alias}" do
        let(:string) { given_alias }

        it "resolves it to #{expected}" do
          is_expected.to eq(expected)
        end
      end
    end
  end

  context "with an exact match" do
    shared_examples_for "exact match" do |mode, all|
      context "for #{mode}" do
        all.each do |match|
          context "that is #{match}" do
            let(:string) { match }

            it "resolves it to itself" do
              is_expected.to eq(match)
            end
          end
        end
      end
    end

    include_examples "exact match", "tube", Tfl::Const::Tube::ALL
    include_examples "exact match", "bus", Tfl::Const::Bus::ALL
    include_examples "exact match", "national rail", Tfl::Const::NationalRail::ALL
    include_examples "exact match", "river bus", Tfl::Const::RiverBus::ALL
    include_examples "exact match", "river tour", Tfl::Const::RiverTour::ALL
  end

  context "with an invalid alias" do
    let(:string) { "invalid" }

    it "returns the original string" do
      is_expected.to eq("invalid")
    end
  end
end
