# frozen_string_literal: true

require "spec_helper"

RSpec.describe Bot::Commands::BusCommand do
  let(:instance) { described_class.new }

  describe "#valid_query?" do
    describe "when given an invalid query" do
      describe "that is an empty string" do
        it "returns false" do
          expect(instance.valid_query?([""])).to be false
          expect(instance.valid_query?([])).to be false
        end
      end

      it "returns false" do
        expect(instance.valid_query?([":scream:"])).to be false
        expect(instance.valid_query?(["..."])).to be false
      end
    end

    describe "when given valid a query" do
      context "as a valid bus" do
        Tfl::Const::Bus::ALL.each do |bus|
          context "that is #{bus}" do
            let(:args) { bus.split }

            it "returns true" do
              expect(instance.valid_query?(args)).to be true
            end
          end
        end
      end
    end
  end
end
