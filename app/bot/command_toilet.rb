# frozen_string_literal: true

require_relative "discord_utils"

module Bot
  module Commands
    class ToiletCommand
      include Loggy

      COMMAND = :toilet

      def self.execute(event)
        ToiletCommand.new.execute(event)
      end

      def execute(event)
        return if event.from_bot?

        args = Commands.split_args(COMMAND, event)
        args = DiscordUtils.filter_mentions(*args, mentions: event.message.mentions)
        return unless valid_query?(args)

        query = args.join(" ")

        log "[command/toilet(from:#{event.user.name})] #{query}"

        station = Tfl::Stations.find(query)
        if station.nil?
          event << "Cannot find #{query}"
        else
          format_station(event, station)
        end

        nil
      end

      def valid_query?(args)
        return false if args.empty?
        return false if args.size == 1 && args.first == ""

        invalid_checks = [
          # Contains valid characters?
          -> { args.map { |arg| (/^[A-Za-z0-9\-'\. ]+$/ =~ arg).nil? }.all? },

          # Contains at least a letter?
          -> { args.map { |arg| (/[A-z]+/ =~ arg).nil? }.all? },

          # Contains emojis?
          -> { args.map { |arg| DiscordUtils::Emoji.emoji?(arg) }.any? }
        ]

        !invalid_checks.map(&:call).any?
      end

      private

      def format_station(event, station)
        toilet = station.facilities.fetch(Tfl::Station::Facility::TOILETS, nil)
        if toilet.nil?
          toilet = "TfL doesn't know. " \
            "May I suggest a trip to #{station.display_name} " \
            "to find out later today? And please, report back."
        end

        event << "**#{station.display_name}** #{DiscordUtils::Emoji::TOILET}: #{toilet}"
      end
    end
  end
end
