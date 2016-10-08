# frozen_string_literal: true
require "discordrb"
require "prius"

require_relative "commands"

Prius.load(:discord_client_id)
Prius.load(:discord_token)

module Bot
  module Config
    PREFIX = "!"
  end

  class LondonBot
    include Bot::Commands

    delegate :invite_url, :run, to: :@bot

    def initialize
      @tfl = Tfl::Api::Client.new
      @bot = Discordrb::Commands::CommandBot.new token: Prius.get(:discord_token),
                                                 client_id: Prius.get(:discord_client_id),
                                                 prefix: Config::PREFIX

      configure_commands(@bot, @tfl)
    end
  end
end
