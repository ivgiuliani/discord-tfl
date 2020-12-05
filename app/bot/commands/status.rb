# frozen_string_literal: true

require_relative "../discord_utils"

module Bot
  module Commands
    class StatusCommand
      include Loggy

      COMMAND = :status

      MAX_LIST_RESPONSE_COUNT = 30
      MAX_QUERY_LENGTH = 42

      def initialize(tfl_api_client: Bot.default_tfl_api_client)
        @tfl_api_client = tfl_api_client
      end

      def self.execute(event, mention: false)
        StatusCommand.new.execute(event, mention: mention)
      end

      def execute(event, mention:)
        return if event.from_bot?

        args = Commands.split_args(COMMAND, event)

        # Only respond to mentions whey we are the 1st mention of the bunch.
        return if mention && !DiscordUtils.mentions_of_self?(event, args.first)

        args = DiscordUtils.filter_mentions(*args, mentions: event.message.mentions)
        return unless valid_query?(args)

        type, entity = status_decode(args)

        log "[command/status(from:#{event.user.name})] " \
          "\"#{args.join(' ')}\" (resolved to #{entity})"

        DiscordUtils::PendingResponse.for(event) do
          format_response(type, entity)
        end

        nil
      end

      def valid_query?(args)
        return true if args.empty?
        return true if args.size == 1 && args.first == ""

        invalid_checks = [
          # Contains valid characters?
          -> { args.map { |arg| (/^[A-Za-z0-9&\- ]+$/ =~ arg).nil? }.all? },

          # Contains emojis?
          -> { args.map { |arg| DiscordUtils::Emoji.emoji?(arg) }.any? },
        ]

        invalid_checks.map(&:call).none?
      end

      def status_decode(args)
        if args.empty?
          entity = Tfl::Const::Mode::METROPOLITAN_TRAINS
          type = :by_mode
        else
          entity = Tfl::IdResolver.resolve(args.join(" ").
              truncate(MAX_QUERY_LENGTH).
              gsub(" ", "-").
              downcase)

          type = :by_id
          type = :by_mode if Tfl::Const::Mode.valid? entity
        end

        [type, entity]
      end

      private

      attr_reader :tfl_api_client

      def format_response(type, entity)
        begin
          response = tfl_api_client.status(type, entity)
        rescue Tfl::InvalidLineException
          return "Woops, that is not a line I recognise"
        rescue Songkick::Transport::TimeoutError
          return "#{DiscordUtils::Emoji::SCREAM} Request timed out (blame TfL)"
        end

        format_status_list!(response)
      end

      def format_status_list!(line_statuses)
        if line_statuses.empty?
          "TfL did not return any data for that query. That's weird!"
        elsif line_statuses.count > MAX_LIST_RESPONSE_COUNT
          "Wow. Much data. Not show."
        else
          line_statuses.map do |line|
            format_status_line(line, detailed: line_statuses.count == 1)
          end.join("\n")
        end
      end

      def format_status_line(line, detailed:)
        if line.good_service? || !detailed
          "**#{line.display_name}**: #{line.current_status}"
        else
          line.disruptions.map do |disruption|
            # TfL sometimes repeats the line's name in the disruption messages.
            # Since it looks slightly ugly, we attempt to drop that repetion on a
            # best effort basis.
            disruption = chop_repetition_on_disruption(disruption, line)

            "**#{line.display_name}**: #{disruption}"
          end.join("\n")
        end
      end

      def chop_repetition_on_disruption(disruption, line)
        return disruption unless disruption.
          downcase.start_with?(line.display_name.downcase)

        disruption = disruption[line.display_name.length..].strip

        # The line could be followed by a "line" word.
        disruption = disruption[4..] if disruption.downcase.start_with?("line")

        # Advance to the first char in a..z skipping any colons or semi colons
        # the string might have.
        while disruption != "" && !("a".."z").cover?(disruption[0].downcase)
          disruption = disruption[1..]
        end

        disruption
      end
    end
  end
end
