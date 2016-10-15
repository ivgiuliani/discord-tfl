# frozen_string_literal: true

require "levenshtein"
require "nokogiri"

require_relative "./data_loader"

module Tfl
  module Stations
    extend Tfl::DataLoader

    MAX_LEVENSHTEIN_DISTANCE = 2

    def self.parse_station(xml)
      station_id = xml.attr("id")
      station_name = xml.xpath("name").text
      station_zone_xml = xml.xpath("zones/zone")[0]
      station_zone = if station_zone_xml.nil?
                       nil
                     else
                       station_zone_xml.text.strip
                     end

      serving_lines = xml.xpath("servingLines/servingLine").map do |line|
        line.text.strip
      end

      facilities = {}.tap do |h|
        xml.xpath("facilities/facility").each do |facility|
          name = facility.attr("name").strip.gsub("&amp;", "&")
          value = facility.text.strip
          h[name] = value if !name.empty? && !value.empty?
        end
      end

      Station.new(station_id,
                  station_name,
                  station_zone,
                  serving_lines,
                  facilities)
    end

    def self.load
      xml = File.open(data_file_path("stations-facilities.xml")) do |f|
        Nokogiri::XML(f)
      end
      xml.xpath("//station").map { |station_xml| parse_station(station_xml) }
    end

    STATION_ALIAS = {
      # IDs are defined in `station-facilities.xml`.
      # Station ID => [Aliases, ...]
      "1000013" => ["hell"],
      "1002025" => ["crossharbour"],
      "1000073" => ["elephant castle"],
      "1000129" => ["king's cross"],
      "1000191" => ["regents park"],
      "1000203" => ["shepherd bush", "shepherd's bush", "shebu"],
      "1000221" => ["st james park"]
    }.freeze

    ALL = load
    NAME_MAP = {}.tap do |h|
      processed_ids = Set.new
      ALL.each do |station|
        if processed_ids.include? station.id
          # TfL's data is not perfect. When this happens, only consider the
          # first match.
          next
        end

        processed_ids << station.id
        h[station.display_name.downcase] = station

        # Augment data with defined aliases.
        STATION_ALIAS.fetch(station.id, []).each do |station_alias|
          h[station_alias] = station
        end
      end
    end

    def self.find(string)
      # Unfortunately stations, unlike bus and tube lines, don't have easy
      # and unique identifiers. Additionally, stations also have sometimes
      # very long names and are might be known to the public under a slightly
      # different name that doesn't include some words.
      # Therefore we need to do a similarity search to find what we might be
      # looking for that also includes some manually defined aliases.
      # We're fairly conservative in applying data transformations so the
      # false positives rate should be low enough.
      similarities = similarity_list(string).
        reject! { |item| item[0] > MAX_LEVENSHTEIN_DISTANCE }.
        sort_by! { |x| x[0] }

      return nil if similarities.empty?

      # Found a match!
      similarities.first[1]
    end

    def self.similarity_list(query)
      normalized_query = query.downcase
      NAME_MAP.map do |name, station|
        [Levenshtein.distance(name, normalized_query), station]
      end
    end

    private_class_method :parse_station
    private_class_method :load
    private_class_method :similarity_list
  end
end
