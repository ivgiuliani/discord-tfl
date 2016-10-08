# frozen_string_literal: true
module Bot
  module Commands
    def configure_commands(bot, tfl_client)
      @tfl = tfl_client

      bot.command(:status) { |event, *args| on_status(event, *args) }
    end

    private

    def on_status(event, *args)
      if args.empty?
        status_list(event, @tfl.status(:by_mode, Tfl::Api::Mode::METROPOLITAN_TRAINS))
      else
        line_state(event, @tfl.status(:by_id, args[0]))
      end

      nil
    end

    def status_list(event, line_statuses)
      line_statuses.each do |line|
        event << "#{line.display_name}: #{line.current_status}"
      end
    end

    def line_state(event, line)
      if line.good_service?
        event << "#{line.display_name}: #{line.current_status}"
      else
        line.disruptions.each do |disruption|
          event << "#{line.display_name}: #{disruption}"
        end
      end
    end
  end
end
