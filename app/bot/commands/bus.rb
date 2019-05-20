# frozen_string_literal: true

require_relative "../discord_utils"

module Bot
  module Commands
    class BusCommand
      include Loggy

      COMMAND = :bus

      def initialize(tfl_api_client: Bot.default_tfl_api_client)
        @tfl_api_client = tfl_api_client
      end

      def self.execute(event)
        BusCommand.new.execute(event)
      end

      def execute(event)
        return if event.from_bot?

        args = Commands.split_args(COMMAND, event)
        args = DiscordUtils.filter_mentions(*args, mentions: event.message.mentions)
        return unless valid_query?(args)

        bus_line = args.first

        log "[command/bus(from:#{event.user.name})] #{bus_line}"

        begin
          bus = tfl_api_client.bus_route(bus_line.strip)

          # \u2192 is a unicode right arrow. The double-ended arrow which would arguably
          # be more correct in this case is displayed as an emoji in Discord for reasons
          # that are beyond me.
          "**#{bus.name}**: " \
            "#{bus.stop_points.first.name} \u2192 #{bus.stop_points.last.name} " \
            "(#{bus.stop_points.count} stops)"
        rescue Tfl::InvalidRouteException, Tfl::InvalidStopPointException
          event << "#{bus_line}: invalid bus line"
          return
        rescue Songkick::Transport::TimeoutError
          event << "#{DiscordUtils::Emoji::SCREAM} Request timed out (blame TfL)"
          return
        end
      end

      def valid_query?(args)
        args.count == 1 && Tfl::Const::Bus::ALL.include?(args.first.strip.downcase)
      end

      private

      attr_reader :tfl_api_client
    end
  end
end
