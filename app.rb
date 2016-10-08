# frozen_string_literal: true
require "./app/tfl/api"
require "./app/tflbot"
require "pry"

bot = Bot::LondonBot.new
$stdout.puts "\nInvite URL: #{bot.invite_url}\n\n"

bot.run
