# frozen_string_literal: true

require "net/http"
require "nokogiri"

module Tfl
  module Scraping
    PRESS_RELEASES_URL = "https://tfl.gov.uk/info-for/media/press-releases"

    PressRelease = Struct.new(:title, :url)

    class PressReleasesFeed
      def initialize(releases: [])
        @releases = releases
      end

      def strikes
        @releases.select { |story| story.title =~ /(strike|industrial action)/i }
      end

      attr_reader :releases

      def update!(raw_html: nil)
        update_from_list(parse_content(raw_html || download_content))
      end

      def update_from_list(new_releases)
        if @releases.empty?
          # We need to special case the first update since we want to update the list but
          # pretend it did not actually change.
          @releases = new_releases
          return false
        end

        has_changed = !new_releases.empty? && new_releases != @releases
        if has_changed
          @releases = new_releases
          true
        else
          false
        end
      end

      private

      def download_content
        Net::HTTP.get(URI(PRESS_RELEASES_URL))
      end

      def parse_content(content)
        doc = Nokogiri::HTML(content)

        items = doc.search("div.vertical-button-container a.plain-button")
        items.map do |item|
          # There's a "<br>" between the title and the date that makes
          # this necessary :(
          title = item.children.first.text.strip
          relative_url = item["href"]

          url = URI.join(PRESS_RELEASES_URL, relative_url).to_s

          PressRelease.new(title, url)
        end
      end
    end
  end
end
