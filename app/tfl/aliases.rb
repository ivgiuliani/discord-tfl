# frozen_string_literal: true

module Tfl
  module Aliases
    ALIASES = {
      "dangleway" => Tfl::Api::Mode::CABLE_CAR,
      "h&c" => Tfl::Api::Tube::HAMMERSMITH,
      "waterloo" => Tfl::Api::Tube::WATERLOO
    }.freeze

    def self.resolve(string)
      ALIASES.fetch(string, string)
    end
  end
end
