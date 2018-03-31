# frozen_string_literal: true

require "net/http"
require "nokogiri"

module Tfl
  module Scraping
    PRESS_RELEASES_URL = "https://tfl.gov.uk/info-for/media/press-releases"

    PressRelease = Struct.new(:title, :url)

    class PressReleasesFeed
      def initialize
        @releases = []
      end

      def strikes
        @releases.select { |story| story.title =~ /(strike|industrial action)/i }
      end

      attr_reader :releases

      def update!(raw_html: nil)
        new_releases = parse_content(raw_html || download_content)
        changed = new_releases != @releases
        @releases = new_releases

        changed
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
          # this necessary :()
          title = item.children.first.text.strip
          relative_url = item["href"]

          url = URI.join(PRESS_RELEASES_URL, relative_url).to_s

          PressRelease.new(title, url)
        end
      end
    end
  end
end
