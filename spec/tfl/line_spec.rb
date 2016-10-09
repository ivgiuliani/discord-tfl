# frozen_string_literal: true
require "spec_helper"

RSpec.describe Tfl::Line do
  describe "#from_api" do
    subject(:line) { described_class.from_api(api_obj) }
    let(:api_obj) { load_fixture_obj("tfl/status_central_good_service").first }

    it "creates a new valid object" do
      expect(line.id).to eq(:central)
      expect(line.mode).to eq("tube")
      expect(line.current_status).to eq("Good Service")
      expect(line.display_name).to eq("Central")
      expect(line.good_service?).to be true
      expect(line.disruptions).to be_empty
    end

    context "when given an invalid object" do
      let(:api_obj) { { x: "y" } }

      it "raises an exception" do
        expect { subject }.to raise_error(Tfl::InvalidLineException)
      end
    end
  end

  describe "#==" do
    let(:line1) { FactoryGirl.build(:line, :central) }
    let(:line2) { FactoryGirl.build(:line, :northern) }
    let(:line3) { FactoryGirl.build(:line, :central) }

    it "returns true for the same line" do
      expect(line1 == line3).to be true
      expect(line3 == line1).to be true
    end

    it "returns false for different lines" do
      expect(line1 == line2).to be false
      expect(line2 == line1).to be false
    end
  end
end
