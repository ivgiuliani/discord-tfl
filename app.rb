# frozen_string_literal: true

require "sentry-raven-without-integrations"
require "optparse"
require "./app/tflbot"

module RufusRavenSupport
  def on_error(job, err)
    Raven.capture_exception(err, extra: { "job": job })
    super
  end
end

# We have to monkey patch the rufus scheduler to support sentry because there's
# no direct way to override the default exception handler.
module Rufus
  class Scheduler
    prepend RufusRavenSupport
  end
end

def parse_opts!
  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: app.rb [options]"

    opts.on("-cCONFIG_PATH", "--config=CONFIG_PATH", "Specify a config file") do |v|
      options[:config] = v
    end
  end.parse!

  options
end

def run
  cmd_opts = parse_opts!

  bot = Bot::LondonBot.new(
    config_path: cmd_opts[:config] || Bot::LondonBot::DEFAULT_CONFIG_PATH,
  )

  begin
    bot.run!
  rescue SignalException
    # Best effort attempt at sending a close-frame to discord. API calls might
    # not be confirmed without a close frame, resulting in unexpected behaviour.
    # See discussion on https://github.com/meew0/discordrb/pull/251#issuecomment-254053322
    # for more details.
    bot.stop!

    $stdout.puts "So long and thanks for all the fish."
    exit! true
  # rubocop:disable Lint/RescueException
  rescue Exception => e
    Raven.capture_exception(e)
  end
  # rubocop:enable Lint/RescueException
end

run
