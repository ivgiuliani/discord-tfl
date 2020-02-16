# frozen_string_literal: true

require_relative "commands/bus"
require_relative "commands/situation"
require_relative "commands/status"
require_relative "commands/station"

module Bot
  module Commands
    extend Discordrb::EventContainer
    extend Discordrb::Commands::CommandContainer

    CommandRequests = Metrics.counter(
      name: "command_requests",
      desc: "A counter of command requests",
      labels: [:command],
    )

    def self.cmd(cmd, klass, description:)
      command(cmd, description: description) do |event|
        CommandRequests.increment(labels: { command: cmd })
        klass.execute(event)
      end
    end
    private_class_method :cmd

    cmd(Commands::BusCommand::COMMAND, Commands::BusCommand,
        description: "The bus")

    cmd(Commands::StatusCommand::COMMAND, Commands::StatusCommand,
        description: "How well is the tube doing?")

    cmd(Commands::SituationCommand::COMMAND, Commands::SituationCommand,
        description: "How are we doing today?")

    cmd(Commands::StationCommand::COMMAND, Commands::StationCommand,
        description: "What do we know about a given station?")

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
