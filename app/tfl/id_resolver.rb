# frozen_string_literal: true
require "levenshtein"

module Tfl
  # Resolves strings to valid TfL identifiers (lines, modes and alike).
  module IdResolver
    MAX_LEVENSHTEIN_DISTANCE = 2

    ALIASES = {
      "bakerloo line" => Tfl::Api::Tube::BAKERLOO,
      "circle line" => Tfl::Api::Tube::CIRCLE,
      "central line" => Tfl::Api::Tube::CENTRAL,
      "district line" => Tfl::Api::Tube::DISTRICT,
      "dangleway" => Tfl::Api::Mode::CABLE_CAR,
      "hammersmith" => Tfl::Api::Tube::HAMMERSMITH,
      "h&c" => Tfl::Api::Tube::HAMMERSMITH,
      "jubilee line" => Tfl::Api::Tube::JUBILEE,
      "northern line" => Tfl::Api::Tube::NORTHERN,
      "piccadilly line" => Tfl::Api::Tube::PICCADILLY,
      "victoria line" => Tfl::Api::Tube::VICTORIA,
      "waterloo" => Tfl::Api::Tube::WATERLOO,
      "w&c" => Tfl::Api::Tube::WATERLOO
    }.freeze

    def self.similarity_list(string, list)
      list.map do |mode|
        [Levenshtein.distance(mode, string), mode]
      end
    end

    def self.similar(string)
      return string if Tfl::Api::Mode.valid? string
      return string if Tfl::Api::Tube.valid? string
      return string if ALIASES.include? string

      similarities =
        similarity_list(string, Tfl::Api::Mode::ALL) +
        similarity_list(string, Tfl::Api::Tube::ALL) +
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
