#!/usr/bin/env ruby
# frozen_string_literal: true
require "open-uri"
require "json"

DOWNLOADS = [
  # [url, output, type]

  # Lines data
  ["https://api.tfl.gov.uk/Line/Mode/bus", "bus_lines.json", :json],
  ["https://api.tfl.gov.uk/Line/Mode/national-rail", "national_rail_lines.json", :json],
  ["https://api.tfl.gov.uk/Line/Mode/river-bus", "river_bus_lines.json", :json],
  ["https://api.tfl.gov.uk/Line/Mode/river-tour", "river_tour_lines.json", :json]
].freeze

DOWNLOADS.each do |download|
  url, output, type = *download

  $stdout.puts "Downloading #{url} => #{output}"

  case type
  when :json
    open(output, "w") do |file|
      file << JSON.pretty_generate(JSON.parse(open(url).read)) << "\n"
    end
  when :xml
    stream = open(url)
    IO.copy_stream(stream, output)
  else
    raise ArgumentError, "Invalid type"
  end
end
