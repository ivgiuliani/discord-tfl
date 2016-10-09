# frozen_string_literal: true
require "./app/tflbot"

bot = Bot::LondonBot.new

begin
  bot.run
rescue SignalException
  $stdout.puts "So long and thanks for all the fish."
  exit! true
end
