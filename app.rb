# frozen_string_literal: true
require "sentry-raven-without-integrations"
require "./app/tflbot"

# We have to monkey patch the rufus scheduler to support sentry because there's
# no direct way to override the default exception handler.
module Rufus
  class Scheduler
    def on_error(job, err)
      Raven.capture_exception(err, extra: { "job": job })
    end
  end
end

bot = Bot::LondonBot.new

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
rescue Exception => exception
  Raven.capture_exception(exception)
end
