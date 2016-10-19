# frozen_string_literal: true
module Tfl
  class InvalidLineException < StandardError; end

  # A "line" is an in-memory representation of a given TfL service such as a
  # tube line, a bus route, a boat service or others.
  class Line
    attr_reader :id, :display_name, :mode, :disruptions, :current_status

    def self.from_api(api_obj)
      requires_key(api_obj, "id")
      requires_key(api_obj, "name")
      requires_key(api_obj, "modeName")
      requires_key(api_obj, "lineStatuses")
      requires_key(api_obj["lineStatuses"].first, "statusSeverityDescription")

      disruptions = []
      api_obj["lineStatuses"].each do |status|
        message = status.fetch("disruption", {}).fetch("description", nil)
        if !message.nil? && !disruptions.include?(message)
          disruptions << message
        end
      end

      # If there are multiple different disruptions, only the first one
      # is used for determine the current status. This is usually accurate
      # since if there's no good service (and therefore there is at least
      # one disruption), showing the first disruptions' type is generally
      # enough to determine that there isn't good service on the line.
      current_status = api_obj["lineStatuses"].first["statusSeverityDescription"]

      new(
        id: api_obj["id"].to_sym,
        display_name: api_obj["name"],
        mode: api_obj["modeName"],
        current_status: current_status,
        disruptions: disruptions
      )
    end

    def self.requires_key(obj, key)
      raise InvalidLineException unless obj.include?(key)
    end
    private_class_method :requires_key

    def initialize(id:, display_name:, mode:, current_status:, disruptions: [])
      @id = id
      @display_name = display_name
      @mode = mode
      @current_status = current_status
      @disruptions = disruptions
    end

    def ==(other)
      @id == other.id
    end

    alias_method :eql?, :==

    def good_service?
      disruptions.empty?
    end
  end
end
