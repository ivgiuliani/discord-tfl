# frozen_string_literal: true
module Bot
  module Commands
    def configure_commands(bot, tfl_client)
      @tfl = tfl_client

      bot.command(:status) { |event, *args| on_status(event, *args) }
    end

    private

    def on_status(event, *args)
      frmt = -> (item) do
        "#{item['name']}: #{item['lineStatuses'].first['statusSeverityDescription']}"
      end

      if args.empty?
        @tfl.status(:by_mode).map do |item|
          event << frmt.call(item)
        end
      else
        on_item_status(event, args[0])

      end

      nil
    end

    def on_item_status(event, id)
      frmt = -> (item) do
        "#{item['name']}: #{item['lineStatuses'].first['statusSeverityDescription']}"
      end

      if Tfl::Api::Mode.valid? id
        @tfl.status(:by_mode, id).map do |item|
          event << frmt.call(item)
        end
      else
        event << frmt.call(@tfl.status(:by_id, id).first)
      end
    end
  end
end
