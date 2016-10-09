# frozen_string_literal: true
require "spec_helper"

def tfl_api_path(path)
  %r{^https:\/\/api.tfl.gov.uk#{path}\?app_id=[\S]+app_key=[\S]+}
end

def stub_tfl_response(path, fixture, status = 200)
  stub_request(:get, tfl_api_path(path)).
    to_return(status: status, body: load_fixture(fixture), headers: {
      "Content-Type": "application/json; charset=utf-8"
    })
end

def stub_tfl_not_found(path)
  stub_request(:get, tfl_api_path(path)).to_return(status: 404)
end

def stub_tfl_invalid(path)
  stub_request(:get, tfl_api_path(path)).to_return(status: 400)
end

RSpec.describe Tfl::Api::Client do
  let(:instance) { described_class.new }

  describe "retrieve status" do
    describe "by id" do
      subject(:api_call) { instance.status_by_id(id) }

      context "for a valid id" do
        context "when there is good service" do
          let(:id) { Tfl::Const::Tube::CENTRAL }

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
          let(:id) { Tfl::Const::Tube::CIRCLE }

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
          let(:id) { Tfl::Const::Tube::DLR }

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

    describe "by mode" do
      subject(:api_call) { instance.status_by_mode(mode) }

      context "for a valid mode" do
        let(:mode) { Tfl::Const::Mode::TUBE }

        before do
          stub_tfl_response("/line/mode/tube/status",
                            "tfl/status_mode_tube_list")
        end

        it "returns all the data" do
          expect(api_call.count).to eq(11)
        end

        it "returns a list of lines" do
          api_call.each do |item|
            expect(item).to be_instance_of Tfl::Line
          end
        end

        context "for a large response" do
          let(:mode) { Tfl::Const::Mode::BUS }

          before do
            stub_tfl_response("/line/mode/bus/status",
                              "tfl/status_mode_bus_list")
          end

          it "returns all the data" do
            expect(api_call.count).to eq(665)
          end

          it "returns a list of lines" do
            api_call.each do |item|
              expect(item).to be_instance_of Tfl::Line
            end
          end
        end
      end

      context "with an invalid mode" do
        let(:mode) { "invalid" }

        context "that returns a not found error" do
          before { stub_tfl_not_found("/line/mode/invalid/status") }

          it "raises an exception" do
            expect { api_call }.to raise_error(Tfl::InvalidLineException)
          end
        end

        context "that returns an invalid-request response " do
          before { stub_tfl_invalid("/line/mode/invalid/status") }

          it "raises an exception" do
            expect { api_call }.to raise_error(Tfl::InvalidLineException)
          end
        end
      end

      context "when tfl returns an empty response" do
        # Happens sometimes :(
        let(:mode) { "empty" }
        before { stub_tfl_response("/line/mode/empty/status", "tfl/status_empty_list") }

        it "returns nil" do
          expect(api_call).to be_empty
        end
      end
    end
  end
end
