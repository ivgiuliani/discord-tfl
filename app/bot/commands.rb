# frozen_string_literal: true

require_relative "commands/bus"
require_relative "commands/situation"
require_relative "commands/status"
require_relative "commands/station"

module Bot
  module Commands
    extend Discordrb::EventContainer
    extend Discordrb::Commands::CommandContainer

    command(Commands::BusCommand::COMMAND,
            description: "The bus") do |event|
      Commands::BusCommand.execute(event)
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
