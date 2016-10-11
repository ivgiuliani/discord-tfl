# frozen_string_literal: true

require_relative "discord_utils"

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
        end

        format_status_list!(event, entity, response)
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
          event << "#{line.display_name}: #{line.current_status}"
        else
          line.disruptions.each do |disruption|
            event << "#{line.display_name}: #{disruption}"
          end
        end
      end
    end
  end
end
