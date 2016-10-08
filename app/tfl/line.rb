# frozen_string_literal: true
module Tfl
  class Line
    attr_reader :id, :display_name, :mode, :disruptions

    def self.from_json(json)
      disruptions = []
      json["lineStatuses"].each do |status|
        if status.key?("disruption")
          disruptions << status["disruption"]["description"]
        end
      end

      new(
        id: json["id"],
        display_name: json["name"],
        mode: json["modeName"],
        disruptions: disruptions
      )
    end

    def initialize(id:, display_name:, mode:, disruptions: [])
      @id = id
      @display_name = display_name
      @mode = mode
      @disruptions = disruptions
    end

    def good_service?
      disruptions.empty?
    end
  end
end
