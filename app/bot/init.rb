# frozen_string_literal: true

require_relative "config"

module Bot
  module Startup
    extend Discordrb::EventContainer
    extend Loggy

    ready do |event|
      bot = event.bot
      bot.profile.username = CONFIG.username
      bot.game = CONFIG.game

      log "Bot connected and ready, say hello to #{bot.profile.username}."
      log "Invite via #{bot.invite_url}"
    end
  end
end
