# frozen_string_literal: true
require "./app/tflbot"

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
end
