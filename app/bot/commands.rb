# frozen_string_literal: true

require_relative "command_status"

module Bot
  module Commands
    extend Discordrb::EventContainer
    extend Discordrb::Commands::CommandContainer

    mention do |event|
      Commands::StatusCommand.execute(event, mention: true)
    end

    command(Commands::StatusCommand::COMMAND,
            description: "Returns the status of the given tube line") do |event|
      Commands::StatusCommand.execute(event)
    end

    def self.split_args(command, event)
      args = event.message.text.split
      full_command_string = "#{CONFIG.prefix}#{command}"

      args.tap do
        args.shift if !args.empty? && args.first.downcase == full_command_string
      end
    end
  end
end
