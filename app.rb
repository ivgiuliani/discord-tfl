# frozen_string_literal: true
require "./app/tfl/api"
require "./app/tflbot"

bot = Bot::LondonBot.new
$stdout.puts "\nInvite URL: #{bot.invite_url}\n\n"

bot.run
