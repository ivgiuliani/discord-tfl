# frozen_string_literal: true

module Tfl
  class InvalidStopPointException < StandardError; end
  class InvalidRouteException < StandardError; end

  class StopPoint
    attr_reader :id, :status, :name

    def self.from_api(api_obj)
      requires_key(api_obj, "id")
      requires_key(api_obj, "status")
      requires_key(api_obj, "name")

      new(
        id: api_obj["id"],
        status: api_obj["status"],
        name: api_obj["name"],
      )
    end

    def self.requires_key(obj, key)
      raise Tfl::InvalidStopPointException unless obj.include?(key)
    end
    private_class_method :requires_key

    def initialize(id:, status:, name:)
      @id = id
      @status = status
      @name = name
    end
  end

  class RouteSequence
    attr_reader :id, :name, :mode, :stop_points

    def self.from_api(api_obj)
      requires_key(api_obj, "lineId")
      requires_key(api_obj, "lineName")
      requires_key(api_obj, "mode")
      requires_key(api_obj, "stopPointSequences")
      requires_key(api_obj["stopPointSequences"].first, "stopPoint")

      stop_points = api_obj["stopPointSequences"].first["stopPoint"].map do |stop_point|
        StopPoint.from_api(stop_point)
      end

      new(
        id: api_obj["lineId"],
        name: api_obj["lineName"],
        mode: api_obj["mode"],
        stop_points: stop_points,
      )
    end

    def self.requires_key(obj, key)
      raise InvalidRouteException unless obj.include?(key)
    end
    private_class_method :requires_key

    def initialize(id:, name:, mode:, stop_points:)
      @id = id
      @name = name
      @mode = mode
      @stop_points = stop_points
    end
  end
end
