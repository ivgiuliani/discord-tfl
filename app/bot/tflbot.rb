# frozen_string_literal: true

require "discordrb"
require "prius"
require "rufus-scheduler"
require "rack"
require "prometheus/middleware/exporter"

require_relative "init"
require_relative "config"
require_relative "commands"
require_relative "tasks"

Prius.load(:discord_client_id)
Prius.load(:discord_token)

module Bot
  CONFIG = Config.new

  def self.default_tfl_api_client
    @default_tfl_api_client ||= Tfl::Api::Client.new
  end

  class LondonBot
    include Loggy

    DEFAULT_CONFIG_PATH = ".tflconfig.yml"

    def initialize(config_path: DEFAULT_CONFIG_PATH)
      if File.exist?(config_path)
        info("Loading config file #{config_path}")
        CONFIG.load_config(config_path)
      end

      @scheduler = Rufus::Scheduler.new
      @task_handlers = {}

      debug "Initializing bot - Discord client id #{Prius.get(:discord_client_id)}"

      @bot = Discordrb::Commands::CommandBot.new token: Prius.get(:discord_token),
                                                 client_id: Prius.get(:discord_client_id),
                                                 prefix: CONFIG.prefix
      @bot.include! Bot::Startup
      @bot.include! Bot::Commands
    end

    def run!
      @bot.run :async
      setup_scheduled_tasks!

      if CONFIG.metrics_port.nil?
        info("Prometheus metrics are disabled")
      else
        info("Prometheus metrics enabled on port #{CONFIG.metrics_port}")
        setup_metrics_server!
      end

      loop do
        sleep 1
      end
    end

    def stop!
      @bot.stop

      raise "Bot didn't disconnect itself after stop!" if @bot.connected?
    end

    private

    def setup_scheduled_tasks!
      @scheduler.every "1h", first: :now do
        task "announce new strikes", Task::AnnounceNewStrikes do |instance|
          instance.run(@bot)
        end
      end
    end

    def setup_metrics_server!
      # Starts a WEBrick server in the background to serve metric requests for prometheus.
      Thread.new do
        health_check = ->(_) { [200, {}, ["healthy"]] }

        # RubyMine gets fooled by `run` as it thinks we're invoking the bot's run method,
        # whereas in practice we're invoking `run` on the Rack::URLMap's instance returned
        # by `.new`.
        # noinspection RubyArgCount
        app = ::Rack::URLMap.new(
          "/" => ::Rack::Builder.new do
            use Prometheus::Middleware::Exporter,
                registry: Prometheus::Client.registry

            run health_check
          end,
        )

        ::Rack::Handler::WEBrick.run(
          app,
          Host: "0.0.0.0",
          Port: CONFIG.metrics_port,
          Logger: WEBrick::Log.new("/dev/null"),
          AccessLog: [],
        )
      end
    end

    def task(name, klass = nil)
      unless @bot.connected?
        warn "aborting #{name}, bot is not connected"
        return
      end

      info "running task: #{name}"

      @task_handlers[name] = klass.new if !klass.nil? && !@task_handlers.key?(name)

      yield(@task_handlers.fetch(name, nil))
    end
  end
end
