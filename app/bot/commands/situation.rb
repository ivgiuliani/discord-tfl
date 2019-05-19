# frozen_string_literal: true

require_relative "../discord_utils"

module Bot
  module Commands
    class SituationCommand
      include Loggy

      COMMAND = :situation

      def initialize(tfl_api_client: Bot.default_tfl_api_client)
        @tfl_api_client = tfl_api_client
      end

      def self.execute(event)
        SituationCommand.new.execute(event)
      end

      def execute(event)
        log "[command/situation(from:#{event.user.name})]"

        begin
          lines = tfl_api_client.status(:by_mode, Tfl::Const::Mode::METROPOLITAN_TRAINS)
        rescue Songkick::Transport::TimeoutError
          event << "#{DiscordUtils::Emoji::SCREAM} Request timed out (blame TfL)"
          return
        end

        severity = Tfl.severity_value(lines)
        log "[severity] current value=#{severity}"
        event << severity_string(severity)

        nil
      end

      private

      attr_reader :tfl_api_client

      def severity_string(severity)
        if severity >= 1.0
          "*\"Good service\"*"
        elsif severity >= 0.8
          "Somehow working #{DiscordUtils::Emoji::CRY}"
        elsif severity >= 0.6
          "Pub it up #{DiscordUtils::Emoji::BEERS}"
        elsif severity >= 0.4
          "Don't bother #{DiscordUtils::Emoji::COLD_SWEAT}"
        elsif severity >= 0.2
          "Hell #{DiscordUtils::Emoji::SCREAM}"
        else
          "Shit's on fire #{DiscordUtils::Emoji::SCREAM}"
        end
      end
    end
  end
end
