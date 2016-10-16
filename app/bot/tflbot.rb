# frozen_string_literal: true
require "discordrb"
require "prius"

require_relative "init"
require_relative "config"
require_relative "commands"

Prius.load(:discord_client_id)
Prius.load(:discord_token)

module Bot
  CONFIG = Config.new
  TFL = Tfl::Api::Client.new

  class LondonBot
    include Loggy

    DEFAULT_CONFIG_PATH = ".tflconfig.yml"

    def initialize
      if File.exist? DEFAULT_CONFIG_PATH
        info("Loading config file #{DEFAULT_CONFIG_PATH}")
        CONFIG.load_config(DEFAULT_CONFIG_PATH)
      end

      @bot = Discordrb::Commands::CommandBot.new token: Prius.get(:discord_token),
                                                 client_id: Prius.get(:discord_client_id),
                                                 prefix: CONFIG.prefix
      @bot.include! Bot::Startup
      @bot.include! Bot::Commands
    end

    def run!
      @bot.run
    end

    def stop!
      @bot.stop

      raise "Bot didn't disconnect itself after stop!" if @bot.connected?
    end
  end
end
