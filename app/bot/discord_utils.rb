# frozen_string_literal: true

module Bot
  module DiscordUtils
    module Emoji
      # Incomplete list, only includes common emojis.
      # A full list of emojis can be seen on http://www.webpagefx.com/tools/emoji-cheat-sheet/.
      BEERS = ":beers:"
      BOWTIE = ":bowtie:"
      COLD_SWEAT = ":cold_sweat:"
      CRY = ":cry:"
      HANKEY = ":hankey:"
      MINUS_1 = ":-1:"
      PLUS_1 = ":+1:"
      POOP = ":poop:"
      RAGE = ":rage:"
      SHIT = ":shit:"
      SIMPLE_SMILE = ":simple_smile:"
      SCREAM = ":scream:"
      SMILE = ":smile:"
      SMILEY = ":smiley:"
      THINKING = ":thinking:"
      TOILET = ":toilet:"

      def self.emoji?(word)
        !(/:[a-z0-9\-+_]+:/ =~ word).nil?
      end
    end

    class PendingResponse
      # Shows a temporary placeholder until the block given returns a value to
      # be displayed.
      def self.for(event,
                   placeholder: "I'm thinking #{Emoji::THINKING}")
        message_holder = event.respond(placeholder)
        final_msg = yield
        message_holder.edit(final_msg)
      end
    end

    # Filter mentions out of list of words.
    def self.filter_mentions(*args, mentions:)
      encoded_mentions = mentions.flat_map { |mention| possible_mentions(mention.id) }
      args.reject { |word| encoded_mentions.include? word }
    end

    # Is the given mention (passed as a String) about ourselves?
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
