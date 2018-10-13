# frozen_string_literal: true

require "levenshtein"

module Tfl
  # Resolves strings to valid TfL identifiers (lines, modes and alike).
  module IdResolver
    MAX_LEVENSHTEIN_DISTANCE = 2

    ALIASES = {
      "bakerloo line" => Tfl::Const::Tube::BAKERLOO,
      "circle line" => Tfl::Const::Tube::CIRCLE,
      "central line" => Tfl::Const::Tube::CENTRAL,
      "district line" => Tfl::Const::Tube::DISTRICT,
      "dangleway" => Tfl::Const::Mode::CABLE_CAR,
      "hammersmith" => Tfl::Const::Tube::HAMMERSMITH,
      "hammersmith and city" => Tfl::Const::Tube::HAMMERSMITH,
      "h&c" => Tfl::Const::Tube::HAMMERSMITH,
      "jubilee line" => Tfl::Const::Tube::JUBILEE,
      "london-overground" => Tfl::Const::Mode::OVERGROUND,
      "northern line" => Tfl::Const::Tube::NORTHERN,
      "piccadilly line" => Tfl::Const::Tube::PICCADILLY,
      "southwestern" => "south-west-trains",
      "victoria line" => Tfl::Const::Tube::VICTORIA,
      "waterloo" => Tfl::Const::Tube::WATERLOO,
      "waterloo and city" => Tfl::Const::Tube::WATERLOO,
      "w&c" => Tfl::Const::Tube::WATERLOO,
    }.freeze

    def self.similarity_list(string, list)
      list.map do |mode|
        [Levenshtein.distance(mode, string), mode]
      end
    end

    def self.similar(string)
      # Give priority to exact matches.
      [Tfl::Const::Mode,
       Tfl::Const::Tube,
       Tfl::Const::Bus,
       Tfl::Const::NationalRail,
       Tfl::Const::RiverBus,
       Tfl::Const::RiverTour].each do |mode|
        return string if mode.valid? string
      end

      # Buses are intentionally excluded from the similarities as we only
      # want exact matches for them.
      similarities =
        similarity_list(string, Tfl::Const::Mode::ALL) +
        similarity_list(string, Tfl::Const::Tube::ALL) +
        similarity_list(string, Tfl::Const::NationalRail::ALL) +
        similarity_list(string, Tfl::Const::RiverBus::ALL) +
        similarity_list(string, Tfl::Const::RiverTour::ALL) +
        similarity_list(string, ALIASES.keys)

      similarities.
        reject! { |item| item[0] > MAX_LEVENSHTEIN_DISTANCE }.
        sort_by! { |x| x[0] }

      return string if similarities.empty?

      # Found a match!
      similarities.first[1]
    end

    def self.resolve(string)
      resolved = similar(string)
      ALIASES.fetch(resolved, resolved)
    end
  end
end
