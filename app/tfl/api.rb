# frozen_string_literal: true
require "songkick/transport"

module Tfl
  module Api
    module Config
      HOST = "https://api.tfl.gov.uk"
      USER_AGENT = "TfL Bot"
      NETWORK_TIMEOUT = 5 # seconds
    end

    module Tube
      BAKERLOO = "bakerloo"
      CENTRAL = "central"
      CIRCLE = "circle"
      DISTRICT = "district"
      DLR = "dlr"
      HAMMERSMITH = "hammersmith-city"
      JUBILEE = "jubilee"
      OVERGROUND = "london-overground"
      METROPOLITAN = "metropolitan"
      NORTHERN = "northern"
      PICCADILLY = "piccadilly"
      VICTORIA = "victoria"
      WATERLOO = "waterloo-city"
    end

    module Mode
      BUS = "bus"
      CABLE_CAR = "cable-car"
      CYCLE = "cycle"
      CYCLE_HIRE = "cycle-hire"
      COACH = "coach"
      DLR = "dlr"
      OVERGROUND = "overground"
      TFLRAIL = "tflrail"
      TRAM = "tram"
      TUBE = "tube"
      NATIONAL_RAIL = "national_rail"
      REPLACEMENT_BUS = "replacement-bus"
      RIVER_BUS = "river-bus"
      RIVER_TOUR = "river-tour"
      WALKING = "walking"

      METROPOLITAN_TRAINS = [
        DLR, OVERGROUND, TUBE
      ].freeze

      ALL = [
        BUS,
        CABLE_CAR,
        CYCLE,
        CYCLE_HIRE,
        COACH,
        DLR,
        NATIONAL_RAIL,
        OVERGROUND,
        TRAM,
        TFLRAIL,
        TUBE,
        REPLACEMENT_BUS,
        RIVER_BUS,
        RIVER_TOUR,
        WALKING
      ].freeze

      def self.valid?(mode)
        ALL.include?(mode)
      end
    end

    class Client
      def initialize
        @client = transport.new(Config::HOST,
                                user_agent: Config::USER_AGENT,
                                timeout: Config::NETWORK_TIMEOUT)
      end

      def status(type, entity)
        case type
        when :by_id
          status_by_id(entity)
        when :by_mode
          status_by_mode(entity)
        else
          raise ArgumentError, "Invalid status type"
        end
      end

      def status_by_mode(mode = Mode::METROPOLITAN_TRAINS)
        @client.get("/line/mode/#{mode}/status").data
      end

      def status_by_id(id)
        @client.get("/line/#{id}/status").data
      end

      private

      def transport
        Songkick::Transport::Curb
      end
    end
  end
end
