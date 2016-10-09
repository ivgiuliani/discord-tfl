# frozen_string_literal: true
module Tfl
  module Const
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

    module NationalRail
      ABELLIO_GREATER_ANGLIA = "abellio-greater-anglia"
      ARRIVA_TRAIN_WALES = "arriva-trains-wales"
      C2C = "c2c"
      CALEDONIAN_SLEEPER = "caledonian-sleeper"
      CHILTERN_RAILWAYS = "chiltern-railways"
      CROSS_COUNTRY = "cross-country"
      EAST_MIDLANDS_TRAINS = "east-midlands-trains"
      FIRST_HULL_TRAINS = "first-hull-trains"
      FIRST_TRANSPENNINE_EXPRESS = "first-transpennine-express"
      GATWICK_EXPRESS = "gatwick-express"
      GRAND_CENTRAL = "grand-central"
      GREAT_NORTHERN = "great-northern"
      GREAT_WESTERN_RAILWAY = "great-western-railway"
      HEATHROW_CONNECT = "heathrow-connect"
      HEATHROW_EXPRESS = "heathrow-express"
      ISLAND_LINE = "island-line"
      LOCAL_EXPRESS_TRAINS = "local-express-trains"
      LONDON_MIDLAND = "london-midland"
      MERSEYRAIL = "merseyrail"
      NORTHERN_RAIL = "northern-rail"
      SCOTRAIL = "scotrail"
      SOUTHEASTERN = "southeastern"
      SOUTHERN = "southern"
      SOUTH_WEST_TRAINS = "south-west-trains"
      THAMESLINK = "thameslink"
      VIRGIN_TRAINS = "virgin-trains"
      VIRGIN_TRAINS_EAST_COAST = "virgin-trains-east-coast"

      ALL = [
        ABELLIO_GREATER_ANGLIA,
        ARRIVA_TRAIN_WALES,
        C2C,
        CALEDONIAN_SLEEPER,
        CHILTERN_RAILWAYS,
        CROSS_COUNTRY,
        EAST_MIDLANDS_TRAINS,
        FIRST_HULL_TRAINS,
        FIRST_TRANSPENNINE_EXPRESS,
        GATWICK_EXPRESS,
        GRAND_CENTRAL,
        GREAT_NORTHERN,
        GREAT_WESTERN_RAILWAY,
        HEATHROW_CONNECT,
        HEATHROW_EXPRESS,
        ISLAND_LINE,
        LOCAL_EXPRESS_TRAINS,
        LONDON_MIDLAND,
        MERSEYRAIL,
        NORTHERN_RAIL,
        SCOTRAIL,
        SOUTHEASTERN,
        SOUTHERN,
        SOUTH_WEST_TRAINS,
        THAMESLINK,
        VIRGIN_TRAINS,
        VIRGIN_TRAINS_EAST_COAST
      ].freeze

      def self.valid?(rail)
        ALL.include? rail
      end
    end
  end
end
