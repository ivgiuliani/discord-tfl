# frozen_string_literal: true

module Tfl
  class InvalidLineException < StandardError; end

  module CommonDisruptionSeverities
    BUS_SERVICE = "Bus Service"
    GOOD_SERVICE = "Good Service"
    MINOR_DELAYS = "Minor Delays"
    PART_CLOSURE = "Part Closure"
    PART_SUSPENDED = "Part Suspended"
    REDUCED_SERVICE = "Reduced Service"
    SEVERE_DELAYS = "Severe Delays"
    SERVICE_CLOSED = "Service Closed"
    SUSPENDED = "Suspended"
  end

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
        # TfL sometimes returns the same disruption multiple times :/
        message = status.fetch("disruption", {}).fetch("description", nil)
        disruptions << message if !message.nil? && !disruptions.include?(message)
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
        disruptions: disruptions,
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

  # Calculates a severity value for the given lines which is a number between
  # 0 and 1, where 1 means good service everywhere and 0 means nothing is
  # working.
  def self.severity_value(lines)
    return 0 if lines.empty?

    severity_map = {
      CommonDisruptionSeverities::BUS_SERVICE => 0.2,
      CommonDisruptionSeverities::GOOD_SERVICE => 1.0,
      CommonDisruptionSeverities::MINOR_DELAYS => 0.8,
      CommonDisruptionSeverities::PART_CLOSURE => 0.2,
      CommonDisruptionSeverities::PART_SUSPENDED => 0.1,
      CommonDisruptionSeverities::REDUCED_SERVICE => 0.3,
      CommonDisruptionSeverities::SEVERE_DELAYS => 0.5,
      CommonDisruptionSeverities::SERVICE_CLOSED => 1.0,
      CommonDisruptionSeverities::SUSPENDED => 0.0,
    }

    severities = lines.map do |line|
      severity_map.fetch(line.current_status, 1.0)
    end

    severities.inject(0) { |sum, x| sum + x } / lines.length
  end
end
