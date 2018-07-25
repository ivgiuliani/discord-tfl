# frozen_string_literal: true

require "songkick/transport"
require "prius"

Prius.load(:tfl_application_id)
Prius.load(:tfl_application_key)

module Tfl
  module Api
    module Config
      HOST = "https://api.tfl.gov.uk"
      USER_AGENT = "TfL Bot"
      NETWORK_TIMEOUT = 5 # seconds
    end

    class Client
      def initialize
        @client = transport.new(Config::HOST,
                                user_agent: Config::USER_AGENT,
                                timeout: Config::NETWORK_TIMEOUT)
      end

      def status(type, entity)
        case type
        when :by_id
          status_by_id(entity)
        when :by_mode
          status_by_mode(entity)
        else
          raise ArgumentError, "Invalid status type"
        end
      end

      def status_by_mode(mode)
        client.get("/line/mode/#{mode}/status", app_key_args).data.map do |line|
          Tfl::Line.from_api(line)
        end
      rescue Songkick::Transport::HttpError => exception
        if [400, 404].include? exception.status
          raise Tfl::InvalidLineException
        else
          raise
        end
      end

      def status_by_id(id)
        json = client.get("/line/#{id}/status", app_key_args).data
        if json.empty?
          # TfL might return an empty list sometimes for uncommon ids such as
          # 'cycle-hire' or 'walking'.
          return []
        end

        # At some point in March 2017, TfL started returning the status of *all* the lines
        # when given an invalid one in input. However given that we don't support fetching
        # multiple line ids at the same time, so we can recognize that this has happened
        # if we get back more than just one item.
        # This is a temporary workaround: we should prevent these requests to be made in
        # the first place. The response that TfL sends back is really big in this case and
        # we can potentially/unintentionally DDoS them.
        raise Tfl::InvalidLineException if json.length > 1

        [Tfl::Line.from_api(json.first)]
      rescue Songkick::Transport::HttpError => exception
        if [400, 404].include? exception.status
          raise Tfl::InvalidLineException
        else
          raise
        end
      end

      def bus_route(bus, direction = "inbound")
        json = client.get("/line/#{bus.upcase}/route/sequence/#{direction}",
                          app_key_args).data
        Tfl::RouteSequence.from_api(json)
      rescue Songkick::Transport::HttpError => exception
        if [400, 404].include? exception.status
          raise Tfl::InvalidRouteException
        else
          raise
        end
      end

      private

      attr_reader :client

      def app_key_args
        {
          app_id: Prius.get(:tfl_application_id),
          app_key: Prius.get(:tfl_application_key)
        }
      end

      def transport
        Songkick::Transport::Curb
      end
    end
  end
end
