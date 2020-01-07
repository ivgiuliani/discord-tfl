#!/usr/bin/env ruby
# frozen_string_literal: true

require "net/http"
require "json"

# rubocop:disable Layout/LineLength
DOWNLOADS = [
  # [url, output, type]

  # Lines data
  ["https://api.tfl.gov.uk/Line/Mode/bus", "bus_lines.json", :json],
  ["https://api.tfl.gov.uk/Line/Mode/national-rail", "national_rail_lines.json", :json],
  ["https://api.tfl.gov.uk/Line/Mode/river-bus", "river_bus_lines.json", :json],
  ["https://api.tfl.gov.uk/Line/Mode/river-tour", "river_tour_lines.json", :json],

  # Stations data
  ["https://data.tfl.gov.uk/tfl/syndication/feeds/stations-facilities.xml", "stations-facilities.xml", :xml],
].freeze
# rubocop:enable Layout/LineLength

def strip_json(json)
  # Removes `created` and `modified` timestamps from the JSON entities as they
  # end up cluttering the diffs and serve no practical purpose.
  if json.instance_of?(Hash)
    json.reject { |k, _| %w[created modified].include?(k) }.
      transform_values(&method(:strip_json))
  elsif json.instance_of?(Array)
    json.map(&method(:strip_json))
  else
    json
  end
end

DOWNLOADS.each do |url, output, type|
  $stdout.puts "Downloading #{url} => #{output}"

  case type
  when :json
    File.open(output, "w") do |file|
      content = Net::HTTP.get(URI(url))
      file << JSON.pretty_generate(strip_json(JSON.parse(content))) << "\n"
    end
  when :xml
    content = Net::HTTP.get(URI(url))
    File.write(output, content)
  else
    raise ArgumentError, "Invalid type"
  end
end
