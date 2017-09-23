# frozen_string_literal: true

require "spec_helper"

RSpec.describe Bot::Commands::StatusCommand do
  let(:instance) { described_class.new }

  describe "#status_decode" do
    let(:args) { [] }
    subject(:type) { instance.status_decode(args)[0] }
    subject(:entity) { instance.status_decode(args)[1] }

    context "when no arguments are given" do
      it "returns the defaults" do
        expect(type).to eq(:by_mode)
        expect(entity).to eq(Tfl::Const::Mode::METROPOLITAN_TRAINS)
      end
    end

    context "when a mode is given" do
      Tfl::Const::Mode::ALL.each do |mode|
        context "that is #{mode}" do
          let(:args) { [mode] }

          it "sets the right type" do
            expect(type).to eq(:by_mode)
          end

          it "set the entity to be the mode itself" do
            expect(entity).to eq(mode)
          end

          context "but it's not an exact match" do
            # Tamper a bit the string so that it's very similar but still different.
            let(:args) { [mode + "a"] }

            it "sets the right type" do
              expect(type).to eq(:by_mode)
            end

            it "set the entity to be the mode itself" do
              expect(entity).to eq(mode)
            end
          end
        end
      end
    end

    context "when a line id is given" do
      modes = [Tfl::Const::Tube,
               Tfl::Const::Bus,
               Tfl::Const::NationalRail,
               Tfl::Const::RiverBus,
               Tfl::Const::RiverTour]

      modes.each do |mode|
        mode::ALL.each do |line|
          context "that is #{line}" do
            let(:args) { [line] }

            it "sets the right type" do
              expect(type).to eq(:by_id)
            end

            it "sets the entity to be the line itself" do
              expect(entity).to eq(line)
            end
          end
        end
      end

      context "for a bus" do
        Tfl::Const::Bus::ALL.each do |bus|
          context "that is #{bus}" do
            let(:args) { [bus + "_"] }

            it "only responds to an exact match" do
              expect(entity).to_not eq(bus)
            end
          end
        end
      end
    end

    context "when a long query is given" do
      let(:args) { ["1234567890123456789012345678901234567890"] }

      it "truncates it" do
        expect(entity).to eq("12345678901234567890123456789012345")
      end
    end
  end

  describe "#valid_query?" do
    describe "when given valid a query" do
      describe "that is an empty string" do
        it "returns true" do
          expect(instance.valid_query?([""])).to be true
        end
      end

      context "when a mode is given" do
        Tfl::Const::Mode::ALL.each do |mode|
          context "that is #{mode}" do
            let(:args) { [mode] }

            it "returns true" do
              expect(instance.valid_query?(args)).to be true
            end
          end
        end
      end

      context "when a line id is given" do
        modes = [Tfl::Const::Tube,
                 Tfl::Const::Bus,
                 Tfl::Const::NationalRail,
                 Tfl::Const::RiverBus,
                 Tfl::Const::RiverTour]
        modes.each do |mode|
          mode::ALL.each do |line|
            context "that is #{line}" do
              let(:args) { [line] }

              it "returns true" do
                expect(instance.valid_query?(args)).to be true
              end
            end
          end
        end
      end

      context "when an alias is given" do
        Tfl::IdResolver::ALIASES.each_key do |line_alias|
          context "that is #{line_alias}" do
            let(:args) { [line_alias] }

            it "returns true" do
              expect(instance.valid_query?(args)).to be true
            end
          end
        end
      end
    end

    describe "that has an emoji" do
      it "returns false" do
        expect(instance.valid_query?(%w[:scream:])).to be false
        expect(instance.valid_query?(%w[:scream: valid])).to be false
        expect(instance.valid_query?(%w[valid :scream:])).to be false
      end

      context "that is a unicode char" do
        it "returns false" do
          expect(instance.valid_query?(%w[\u{1F631}])).to be false
        end
      end
    end
  end
end
