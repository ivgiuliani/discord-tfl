# frozen_string_literal: true
require "spec_helper"

RSpec.describe Tfl::Api::Client do
  let(:instance) { described_class.new }

  describe "retrieve status" do
    describe "by id" do
      subject(:api_call) { instance.status_by_id(id) }

      context "for the tube" do
        context "when there is good service" do
          let(:id) { Tfl::Api::Tube::CENTRAL }

          before do
            stub_tfl_response("/line/central/status",
                              "tfl/status_central_good_service")
          end

          it "is a line object" do
            is_expected.to be_instance_of Tfl::Line
          end

          it "has the central line" do
            expect(api_call.id).to eq("central")
          end

          it "has good service" do
            expect(api_call.good_service?).to be true
            expect(api_call.disruptions).to be_empty
            expect(api_call.current_status).to match(/Good Service/i)
          end
        end

        context "when there is a planned closure" do
          let(:id) { Tfl::Api::Tube::CIRCLE }

          before do
            stub_tfl_response("/line/circle/status",
                              "tfl/status_circle_planned_closure")
          end

          it "is a line object" do
            is_expected.to be_instance_of Tfl::Line
          end

          it "has the circle line" do
            expect(api_call.id).to eq("circle")
          end

          it "has disruptions" do
            expect(api_call.good_service?).to be false
            expect(api_call.disruptions).to_not be_empty
            expect(api_call.disruptions.first).to match(/no service/i)
            expect(api_call.current_status).to match(/Planned Closure/i)
          end
        end

        context "when there is a part closure" do
          let(:id) { Tfl::Api::Tube::DLR }

          before do
            stub_tfl_response("/line/dlr/status",
                              "tfl/status_dlr_part_closure")
          end

          it "is a line object" do
            is_expected.to be_instance_of Tfl::Line
          end

          it "has the dlr" do
            expect(api_call.id).to eq("dlr")
          end

          it "has disruptions" do
            expect(api_call.good_service?).to be false
            expect(api_call.disruptions).to_not be_empty
            expect(api_call.disruptions.first).to match(/no service/i)
            expect(api_call.current_status).to match(/Part Closure/i)
          end
        end
      end

      context "with an invalid id" do
        let(:id) { "invalid" }

        context "that returns a not found error" do
          before { stub_tfl_not_found("/line/invalid/status") }

          it "raises an exception" do
            expect { api_call }.to raise_error(Tfl::InvalidLineException)
          end
        end

        context "that returns an invalid-request response " do
          before { stub_tfl_invalid("/line/invalid/status") }

          it "raises an exception" do
            expect { api_call }.to raise_error(Tfl::InvalidLineException)
          end
        end
      end

      context "when tfl returns an empty response" do
        # Happens sometimes :(
        let(:id) { "empty" }
        before { stub_tfl_response("/line/empty/status", "tfl/status_empty_list") }

        it "returns nil" do
          expect(api_call).to be_nil
        end
      end
    end
  end
end
