# frozen_string_literal: true

require_relative "command_situation"
require_relative "command_status"
require_relative "command_station"
require_relative "command_toilet"

module Bot
  module Commands
    extend Discordrb::EventContainer
    extend Discordrb::Commands::CommandContainer

    mention do |event|
      Commands::StatusCommand.execute(event, mention: true)
    end

    command(Commands::StatusCommand::COMMAND,
            description: "How well is the tube doing?") do |event|
      Commands::StatusCommand.execute(event)
    end

    command(Commands::SituationCommand::COMMAND,
            description: "How are we doing today?") do |event|
      Commands::SituationCommand.execute(event)
    end

    command(Commands::StationCommand::COMMAND,
            description: "What do we know about a given station?") do |event|
      Commands::StationCommand.execute(event)
    end

    command(Commands::ToiletCommand::COMMAND,
            description: "Does this station have a toilet?") do |event|
      Commands::ToiletCommand.execute(event)
    end

    def self.split_args(command, event)
      args = event.message.text.split
      full_command_string = "#{CONFIG.prefix}#{command}"

      args.tap do
        args.shift if !args.empty? && args.first.downcase == full_command_string
      end

      args.reject { |arg| arg.nil? || arg == "" }
    end
  end
end
