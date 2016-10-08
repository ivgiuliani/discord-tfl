# frozen_string_literal: true
require "songkick/transport"

module Tfl
  module Api
    module Config
      HOST = "https://api.tfl.gov.uk"
      USER_AGENT = "TfL Bot"
      NETWORK_TIMEOUT = 5 # seconds
    end

    module Tube
      BAKERLOO = "bakerloo"
      CENTRAL = "central"
      CIRCLE = "circle"
      DISTRICT = "district"
      DLR = "dlr"
      HAMMERSMITH = "hammersmith-city"
      JUBILEE = "jubilee"
      OVERGROUND = "london-overground"
      METROPOLITAN = "metropolitan"
      NORTHERN = "northern"
      PICCADILLY = "piccadilly"
      VICTORIA = "victoria"
      WATERLOO = "waterloo-city"
    end

    module Mode
      BUS = "bus"
      DLR = "dlr"
      OVERGROUND = "overground"
      TFLRAIL = "tflrail"
      TUBE = "tube"

      METROPOLITAN_TRAINS = [
        DLR, OVERGROUND, TUBE
      ].freeze

      ALL = [BUS, DLR, OVERGROUND, TFLRAIL, TUBE].freeze
    end

    class Client
      def initialize
        @client = transport.new(Config::HOST,
                                user_agent: Config::USER_AGENT,
                                timeout: Config::NETWORK_TIMEOUT)
      end

      def status(type, *args)
        case type
        when :by_id
          status_by_id(*args)
        when :by_mode
          status_by_mode(*args)
        else
          raise ArgumentError, "Invalid status type"
        end
      end

      def status_by_mode(mode = Mode::METROPOLITAN_TRAINS)
        @client.get("/line/mode/#{join(mode)}/status").data
      end

      def status_by_id(ids)
        @client.get("/line/#{join(ids)}/status").data
      end

      private

      def join(item)
        return item.join(",") if item.respond_to? :each
        item
      end

      def transport
        Songkick::Transport::Curb
      end
    end
  end
end
