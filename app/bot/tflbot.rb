# frozen_string_literal: true
require "discordrb"
require "prius"

require_relative "init"
require_relative "config"
require_relative "commands"

Prius.load(:discord_client_id)
Prius.load(:discord_token)

module Bot
  class LondonBot
    DEFAULT_CONFIG_PATH = ".tflconfig.yml"

    include Bot::Config
    include Bot::Commands
    include Loggy

    delegate :invite_url, :run, to: :@bot

    def initialize
      if File.exist? DEFAULT_CONFIG_PATH
        info("Loading config file #{DEFAULT_CONFIG_PATH}")
        load_config(DEFAULT_CONFIG_PATH)
      end

      @tfl = Tfl::Api::Client.new
      @bot = Discordrb::Commands::CommandBot.new token: Prius.get(:discord_token),
                                                 client_id: Prius.get(:discord_client_id),
                                                 prefix: cfg_prefix
      @bot.include! Bot::Startup

      configure_commands(@bot, @tfl)
    end
  end
end
