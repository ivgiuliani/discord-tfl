# frozen_string_literal: true
module Tfl
  class InvalidLineException < StandardError; end

  class Line
    attr_reader :id, :display_name, :mode, :disruptions, :current_status

    def self.from_json(json)
      disruptions = []
      json["lineStatuses"].each do |status|
        if status.key?("disruption")
          disruptions << status["disruption"]["description"]
        end
      end

      # If there are multiple different disruptions, only the first one
      # is used for determine the current status. This is usually accurate
      # since if there's no good service (and therefore there is at least
      # one disruption), showing the first disruptions' type is generally
      # enough to determine that there isn't good service on the line.
      current_status = json["lineStatuses"].first["statusSeverityDescription"]

      new(
        id: json["id"],
        display_name: json["name"],
        mode: json["modeName"],
        current_status: current_status,
        disruptions: disruptions
      )
    end

    def initialize(id:, display_name:, mode:, current_status:, disruptions: [])
      @id = id
      @display_name = display_name
      @mode = mode
      @current_status = current_status
      @disruptions = disruptions
    end

    def good_service?
      disruptions.empty?
    end
  end
end
