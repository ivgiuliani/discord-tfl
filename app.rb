# frozen_string_literal: true
require "./app/tfl/api"
require "./app/tflbot"

bot = Bot::LondonBot.new
$stdout.puts "Bot invite URL: #{bot.invite_url}"

begin
  bot.run
rescue SignalException
  $stdout.puts "So long and thanks for all the fish."
  exit!
end
