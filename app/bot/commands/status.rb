# frozen_string_literal: true

require_relative "../discord_utils"

module Bot
  module Commands
    class StatusCommand
      include Loggy

      COMMAND = :status

      MAX_LIST_RESPONSE_COUNT = 30
      MAX_QUERY_LENGTH = 35

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

        evaluate_and_respond(event, type, entity)

        nil
      end

      def evaluate_and_respond(event, type, entity)
        begin
          response = TFL.status(type, entity)
        rescue Tfl::InvalidLineException
          event << "#{entity}: invalid line"
          return
        rescue Songkick::Transport::TimeoutError
          event << "#{DiscordUtils::Emoji::SCREAM} Request timed out (blame TfL)"
          return
        end

        format_status_list!(event, entity, response)
      end

      def valid_query?(args)
        return true if args.empty?
        return true if args.size == 1 && args.first == ""

        invalid_checks = [
          # Contains valid characters?
          -> { args.map { |arg| (/^[A-Za-z0-9&\- ]+$/ =~ arg).nil? }.all? },

          # Contains emojis?
          -> { args.map { |arg| DiscordUtils::Emoji.emoji?(arg) }.any? }
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
              downcase)

          type = :by_id
          type = :by_mode if Tfl::Const::Mode.valid? entity
        end

        [type, entity]
      end

      def format_status_list!(event, original_query, line_statuses)
        if line_statuses.empty?
          event << "TfL did not return any data for #{original_query}"
        elsif line_statuses.count > MAX_LIST_RESPONSE_COUNT
          event << "Wow. Much data. Not show."
        else
          line_statuses.each do |line|
            format_status_line(event, line, detailed: line_statuses.count == 1)
          end
        end
      end

      def format_status_line(event, line, detailed:)
        if line.good_service? || !detailed
          event << "**#{line.display_name}**: #{line.current_status}"
        else
          line.disruptions.each do |disruption|
            # TfL sometimes repeats the line's name in the disruption messages.
            # Since it looks slightly ugly, we attempt to drop that repetion on a
            # best effort basis.
            disruption = chop_repetition_on_disruption(disruption, line)

            event << "**#{line.display_name}**: #{disruption}"
          end
        end
      end

      def chop_repetition_on_disruption(disruption, line)
        return disruption unless disruption.
            downcase.start_with?(line.display_name.downcase)

        disruption = disruption[line.display_name.length..-1].strip

        # The line could be followed by a "line" word.
        if disruption.downcase.start_with?("line")
          disruption = disruption[4..-1]
        end

        # Advance to the first char in a..z skipping any colons or semi colons
        # the string might have.
        while disruption != "" && !("a".."z").cover?(disruption[0].downcase)
          disruption = disruption[1..-1]
        end

        disruption
      end
    end
  end
end
