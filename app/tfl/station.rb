# frozen_string_literal: true
module Tfl
  class Station
    # Beware the stations might not have all the listed facilities and
    # also that they might have more than those listed here. These are
    # only provided as reference for the common facilities.
    module Facility
      TICKET_HALLS = "Ticket Halls"
      LIFTS = "Lifts"
      ESCALATORS = "Escalators"
      GATES = "Gates"
      TOILETS = "Toilets"
      PHOTO_BOOTHS = "Photo Booths"
      CASH_MACHINES = "Cash Machines"
      PAYPHONES = "Payphones"
      CAR_PARK = "Car park"
      VENDING_MACHINES = "Vending Machines"
      HELP_POINTS = "Help Points"
      BRIDGE = "Bridge"
      WAITING_ROOM = "Waiting Room"
      OTHER = "Other Facilities"
    end

    attr_reader :id, :display_name, :zone, :serving_lines, :facilities

    def initialize(id, display_name, zone, serving_lines, facilities)
      @id = id
      @display_name = display_name
      @zone = zone
      @serving_lines = serving_lines || []
      @facilities = facilities || {}
    end

    def to_s
      @display_name
    end

    def zone?
      !zone.nil?
    end

    def facilities?
      !facilities.empty?
    end

    def serving_lines?
      !serving_lines.empty?
    end
  end
end
