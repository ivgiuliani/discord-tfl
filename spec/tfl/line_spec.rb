# frozen_string_literal: true
require "spec_helper"

RSpec.describe Tfl::Line do
  describe ".from_api" do
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

    context "when given multiple identical disruptions" do
      # TfL does that from time to time.
      let(:api_obj) { load_fixture_obj("tfl/status_mode_tube_multiple_failures").first }

      it "removes the duplicates" do
        expect(subject.disruptions.count).to eq(1)
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

  describe ".severity_value" do
    let(:good_service) { FactoryGirl.build(:line, :good_service) }
    let(:minor_delays) { FactoryGirl.build(:line, :minor_delays) }
    let(:severe_delays) { FactoryGirl.build(:line, :severe_delays) }
    let(:part_closure) { FactoryGirl.build(:line, :part_closure) }
    let(:part_suspended) { FactoryGirl.build(:line, :part_suspended) }
    let(:suspended) { FactoryGirl.build(:line, :suspended) }

    context "when everything's good" do
      it "returns 1.0" do
        expect(Tfl.severity_value([good_service])).to eq(1.0)
        expect(Tfl.severity_value([good_service, good_service])).to eq(1.0)
        expect(Tfl.severity_value([good_service, good_service, good_service])).to eq(1.0)
      end
    end

    context "when it's almost good" do
      it "returns a value close to 1.0" do
        expect(Tfl.severity_value([good_service,
                                   good_service,
                                   good_service,
                                   minor_delays])).to be >= 0.90
      end
    end

    context "when everything is broken" do
      it "returns 0.0" do
        expect(Tfl.severity_value([suspended])).to eq(0.0)
        expect(Tfl.severity_value([suspended, suspended, suspended])).to eq(0.0)
      end
    end

    context "when trains are kind of running" do
      it "returns a value >= 0.5" do
        expect(Tfl.severity_value([good_service,
                                   minor_delays,
                                   minor_delays])).to be >= 0.5
      end
    end

    context "when it's better to pretend this is not happening" do
      it "returns a value <= 0.5" do
        expect(Tfl.severity_value([severe_delays,
                                   part_suspended,
                                   minor_delays])).to be <= 0.5
      end
    end
  end
end
