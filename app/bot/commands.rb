# frozen_string_literal: true
module Bot
  module Commands
    extend Discordrb::EventContainer
    extend Discordrb::Commands::CommandContainer
    extend Loggy

    MAX_LIST_RESPONSE_COUNT = 30
    MAX_QUERY_LENGTH = 35

    mention do |event|
      on_status(event, *event.message.text.split)
    end
    command(:status,
            description: "Returns the status of the given tube line") do |event, *args|
      on_status(event, *args)
    end

    def self.on_status(event, *args)
      return if event.from_bot?

      args = filter_mentions(*args, mentions: event.message.mentions)
      type, entity = status_decode(args)

      log "[command/status(from:#{event.user.name})] " \
        "\"#{args.join(' ')}\" (resolved to #{entity})"

      begin
        response = TFL.status(type, entity)
      rescue Tfl::InvalidLineException
        event << "#{entity}: invalid line"
        return nil
      end

      if response.respond_to?(:each)
        status_list(event, entity, response)
      else
        status_single_item(event, response)
      end

      nil
    end

    def self.status_decode(args)
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

    def self.status_list(event, original_query, line_statuses)
      if line_statuses.empty?
        event << "TfL did not return any data for #{original_query}"
        return
      end

      if line_statuses.count > MAX_LIST_RESPONSE_COUNT
        event << "Wow. Much data. Not show."
        return
      end

      line_statuses.each do |line|
        status_single_item(event, line, detailed: line_statuses.count == 1)
      end
    end

    def self.status_single_item(event, line, detailed: true)
      if line.nil?
        event << "#{entity}: TfL did not return any data :("
      elsif line.good_service? || !detailed
        event << "#{line.display_name}: #{line.current_status}"
      else
        line.disruptions.each do |disruption|
          event << "#{line.display_name}: #{disruption}"
        end
      end
    end

    def self.filter_mentions(*args, mentions:)
      # Mentions are encoded within something that looks like an HTML tag and
      # there's no 100% reliable way to filter them out. See:
      # https://discordapp.com/developers/docs/resources/channel#message-formatting
      encoded_mentions = mentions.flat_map do |mention|
        [
          "<@#{mention.id}>", # User
          "<!@#{mention.id}>", # User (Nickname)
          "<\##{mention.id}>", # Channel
          "<@&#{mention.id}>", # Role
        ].freeze
      end

      args.reject { |word| encoded_mentions.include? word }
    end

    private_class_method :filter_mentions
  end
end
