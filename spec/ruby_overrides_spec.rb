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

  describe "#title" do
    it { expect("oneword".title).to eq("Oneword") }
    it { expect("two words".title).to eq("Two Words") }
    it { expect("Don't Change".title).to eq("Don't Change") }
  end
end
