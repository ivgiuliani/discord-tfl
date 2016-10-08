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
        entity = Tfl::Api::Mode::METROPOLITAN_TRAINS
        type = :by_mode
      else
        entity = args[0].downcase
        type = :by_id
        type = :by_mode if Tfl::Api::Mode.valid? entity
      end

      begin
        response = @tfl.status(type, entity)
      rescue Tfl::InvalidLineException
        event << "#{entity}: invalid line"
        return nil
      end

      if response.respond_to?(:each)
        status_list(event, response)
      else
        status_single_item(event, response)
      end

      nil
    end

    def status_list(event, line_statuses)
      line_statuses.each do |line|
        event << "#{line.display_name}: #{line.current_status}"
      end
    end

    def status_single_item(event, line)
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
