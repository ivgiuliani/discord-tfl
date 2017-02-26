# frozen_string_literal: true

module Bot
  module Task
    class CheckPressReleases
      include Loggy

      def initialize
        @feed = Tfl::Scraping::PressReleasesFeed.new
        @feed.update!
        @releases = @feed.releases
      end

      def new_press_release
        @feed.update!
        new_releases = @feed.releases

        has_new = new_releases != @releases
        @releases = new_releases

        if has_new
          log "[new press release detected] #{@releases.first.title}"
          return @releases.first
        end

        nil
      end
    end
  end
end
