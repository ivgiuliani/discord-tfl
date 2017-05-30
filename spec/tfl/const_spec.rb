# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tfl::Const do
  shared_examples_for "valid?" do |mod, valid_states|
    valid_states.each do |valid|
      context "#{valid} is a valid state" do
        it "returns true" do
          expect(mod.valid?(valid)).to be true
        end
      end
    end

    context "for an invalid state" do
      it "returns false" do
        expect(mod.valid?("invalid")).to be false
      end
    end
  end

  describe "for tube" do
    include_examples "valid?", Tfl::Const::Tube, Tfl::Const::Tube::ALL
  end

  describe "for modes" do
    include_examples "valid?", Tfl::Const::Mode, Tfl::Const::Mode::ALL
  end

  describe "for national rail" do
    include_examples "valid?", Tfl::Const::NationalRail, Tfl::Const::NationalRail::ALL
  end
end
