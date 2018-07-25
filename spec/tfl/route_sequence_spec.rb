# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tfl::RouteSequence do
  describe ".from_api" do
    subject(:route_sequence) { described_class.from_api(api_obj) }
    let(:api_obj) { load_fixture_obj("tfl/bus_n15_route_sequence") }

    it "creates a new valid object" do
      expect(route_sequence.id).to eq("n15")
      expect(route_sequence.name).to eq("N15")
      expect(route_sequence.mode).to eq("bus")
      expect(route_sequence.stop_points.count).to eq(87)
    end

    context "when parsing stop points" do
      subject(:stop_points) { route_sequence.stop_points }

      it "parses them in the right class" do
        expect(stop_points.map(&:class).uniq).to eq([Tfl::StopPoint])
      end
    end

    context "when given an invalid object" do
      let(:api_obj) { { x: "y" } }

      it "raises an exception" do
        expect { subject }.to raise_error(Tfl::InvalidRouteException)
      end
    end
  end
end
