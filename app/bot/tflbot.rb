# frozen_string_literal: true
require "discordrb"
require "prius"
require "rufus-scheduler"

require_relative "init"
require_relative "config"
require_relative "commands"
require_relative "tasks"

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

      @scheduler = Rufus::Scheduler.new
      @task_handlers = {}

      @bot = Discordrb::Commands::CommandBot.new token: Prius.get(:discord_token),
                                                 client_id: Prius.get(:discord_client_id),
                                                 prefix: CONFIG.prefix
      @bot.include! Bot::Startup
      @bot.include! Bot::Commands
    end

    def run!
      @bot.run :async
      setup_scheduled_tasks

      loop do
        sleep 1
      end
    end

    def stop!
      @bot.stop

      raise "Bot didn't disconnect itself after stop!" if @bot.connected?
    end

    private

    def setup_scheduled_tasks
      @scheduler.every "1h", first: :now do
        task "announce new strikes", Task::AnnounceNewStrikes do |instance|
          instance.run(@bot)
        end
      end
    end

    def task(name, klass = nil)
      unless @bot.connected?
        warn "aborting #{name}, bot is not connected"
        return
      end

      info "running task: #{name}"

      unless klass.nil?
        @task_handlers[name] = klass.new unless @task_handlers.key?(name)
      end

      yield(@task_handlers.fetch(name, nil))
    end
  end
end
