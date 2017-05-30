# frozen_string_literal: true

require "spec_helper"

RSpec.describe String do
  describe "#truncate" do
    it "truncates a string longer than the threshold" do
      expect("1234567890".truncate(5)).to eq("12345")
    end

    it "keeps a string shorter than the threshold length untouched" do
      expect("123".truncate(5)).to eq("123")
    end
  end
end
