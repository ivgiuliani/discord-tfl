# frozen_string_literal: true

require "json"

module Tfl
  module Const
    def self.inject_from_json(json_path)
      path = "#{File.dirname(__FILE__)}/data"
      content = File.read(File.join(path, "#{json_path}.json"))
      JSON.parse(content).map do |item|
        item["id"]
      end
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

      ALL = [
        BAKERLOO,
        CENTRAL,
        CIRCLE,
        DISTRICT,
        DLR,
        HAMMERSMITH,
        JUBILEE,
        OVERGROUND,
        METROPOLITAN,
        NORTHERN,
        PICCADILLY,
        VICTORIA,
        WATERLOO
      ].freeze

      def self.valid?(line)
        ALL.include? line
      end
    end

    module Bus
      ALL = Const.inject_from_json("bus_lines")

      def self.valid?(line)
        ALL.include? line
      end
    end

    module NationalRail
      ALL = Const.inject_from_json("national_rail_lines")

      def self.valid?(rail)
        ALL.include? rail
      end
    end
  end
end
