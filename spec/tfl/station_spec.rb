# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tfl::Station do
  let(:id) { "123456" }
  let(:display_name) { "The Station" }
  let(:zone) { "1" }
  let(:serving_lines) { %w[Circle District] }
  let(:facilities) do
    {
      Tfl::Station::Facility::TOILETS => "yes"
    }
  end

  let(:station) do
    described_class.new(id, display_name, zone, serving_lines, facilities)
  end

  describe "#to_s" do
    it "returns the display name" do
      expect(station.to_s).to eq("The Station")
    end
  end

  describe "#zone?" do
    context "when one is given" do
      it "returns true" do
        expect(station.zone?).to be true
      end
    end

    context "when there's no data available" do
      let(:zone) { nil }
      it "returns false" do
        expect(station.zone?).to be false
      end
    end
  end

  describe "#serving_lines?" do
    context "when given" do
      it "returns true" do
        expect(station.serving_lines?).to be true
      end
    end

    context "when there's no data available" do
      let(:serving_lines) { [] }
      it "returns false" do
        expect(station.serving_lines?).to be false
      end
    end
  end

  describe "#facilities?" do
    context "when one is given" do
      it "returns true" do
        expect(station.facilities?).to be true
      end
    end

    context "when there's no data available" do
      let(:facilities) { {} }
      it "returns false" do
        expect(station.facilities?).to be false
      end
    end
  end
end
