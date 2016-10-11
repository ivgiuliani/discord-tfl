# frozen_string_literal: true

module Bot
  module DiscordUtils
    # Filter mentions out of list of words.
    def self.filter_mentions(*args, mentions:)
      encoded_mentions = mentions.flat_map { |mention| possible_mentions(mention.id) }
      args.reject { |word| encoded_mentions.include? word }
    end

    def self.mentions_of_self?(event, mention)
      possible_mentions(event.bot.profile.id).include? mention
    end

    def self.possible_mentions(id)
      # Mentions are encoded within something that looks like an HTML tag and
      # there's no 100% reliable way to filter them out. See:
      # https://discordapp.com/developers/docs/resources/channel#message-formatting
      [
        "<@#{id}>", # User
        "<!@#{id}>", # User (Nickname)
        "<\##{id}>", # Channel
        "<@&#{id}>", # Role
      ].freeze
    end

    private_class_method :possible_mentions
  end
end
