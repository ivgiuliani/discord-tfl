# frozen_string_literal: true
require "spec_helper"

RSpec.describe Tfl::Aliases do
  subject { described_class.resolve(string) }

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
