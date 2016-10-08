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
      NATIONAL_RAIL = "national-rail"
      REPLACEMENT_BUS = "replacement-bus"
      RIVER_BUS = "river-bus"
      RIVER_TOUR = "river-tour"
      WALKING = "walking"

      # Special mode that includes the common means of transportation.
      METROPOLITAN_TRAINS = [
        DLR, OVERGROUND, TUBE
      ].join(",")

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

      def status_by_mode(mode)
        @client.get("/line/mode/#{mode}/status").data.map do |line|
          Tfl::Line.from_json(line)
        end
      rescue Songkick::Transport::HttpError => exception
        if [400, 404].include? exception.status
          raise Tfl::InvalidLineException
        else
          raise
        end
      end

      def status_by_id(id)
        json = @client.get("/line/#{id}/status").data
        if json.empty?
          # TfL might return an empty list sometimes for uncommon ids such as
          # 'cycle-hire' or 'walking'.
          return nil
        end
        Tfl::Line.from_json(json.first)
      rescue Songkick::Transport::HttpError => exception
        if [400, 404].include? exception.status
          raise Tfl::InvalidLineException
        else
          raise
        end
      end

      private

      def transport
        Songkick::Transport::Curb
      end
    end
  end
end
