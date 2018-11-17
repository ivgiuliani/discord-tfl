# frozen_string_literal: true

module Bot
  module Task
    class AnnounceNewStrikes
      include Loggy

      def initialize
        @feed = Tfl::Scraping::PressReleasesFeed.new
        @feed.update!
        @strikes = @feed.strikes
      end

      def run(bot)
        strike = fetch_press_releases
        unless strike.nil?
          log "[new strike detected] #{strike.first.title}"
          announce(bot, strike)
        end
      end

      private

      def announce(bot, strike)
        CONFIG.pr_announce_channels_ids.each do |channel_id|
          bot.send_message(
            channel_id,
            "**New press release from TfL**: #{strike.title}. Read more at #{strike.url}",
          )
        end
      end

      def fetch_press_releases
        @feed.update!
        new_strikes = @feed.strikes

        has_new = (
          new_strikes.map { |r| press_release_comparable(r) } !=
          @strikes.map { |r| press_release_comparable(r) }
        )
        if has_new
          debug("new strike detected -" \
                " old list: " + @strikes.map(&:inspect).to_s +
                " new list: " + new_strikes.map(&:inspect).to_s +
                " will announce: " + new_strikes.first.inspect)
        end
        @strikes = new_strikes

        return @strikes.first if has_new

        nil
      end

      def press_release_comparable(release)
        release.title.downcase.strip.tr("\n", " ").squeeze(" ")
      end
    end
  end
end
