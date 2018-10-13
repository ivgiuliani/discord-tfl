# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tfl::Scraping::PressReleasesFeed do
  let(:instance) { described_class.new(releases: releases) }
  let(:releases) { [] }
  let!(:raw_html) { load_fixture("tfl/press-releases", type: "html") }

  context "when it's the first update" do
    let(:releases) { [] }
    let(:dummy_list) do
      [
        Tfl::Scraping::PressRelease.new("Sample release", "https://google.com"),
      ]
    end

    it "returns false when it gets the list for the first time" do
      expect(instance.update_from_list(dummy_list)).to be false
    end

    context "and gets a second update that changes the list again" do
      before { instance.update_from_list(dummy_list) }

      it "returns true when updating" do
        expect(instance.update!(raw_html: raw_html)).to be true
      end
    end
  end

  context "when the content has changed between scans" do
    let(:releases) do
      [
        Tfl::Scraping::PressRelease.new("Sample release", "https://google.com"),
      ]
    end

    it "returns true when updating" do
      expect(instance.update!(raw_html: raw_html)).to be true
    end
  end

  context "when the content has been downloaded" do
    before { instance.update!(raw_html: raw_html) }

    # rubocop:disable Metrics/LineLength
    it "returns a list of press releases" do
      expect(instance.releases).to match_array([
        Tfl::Scraping::PressRelease.new("Travel advice for customers during today's strike",
                                        "https://tfl.gov.uk/info-for/media/press-releases/2017/february/travel-advice-for-customers-during-today-s-strike"),
        Tfl::Scraping::PressRelease.new("TfL response to RAIB February interim report",
                                        "https://tfl.gov.uk/info-for/media/press-releases/2017/february/tfl-response-to-raib-february-interim-report"),
        Tfl::Scraping::PressRelease.new("Advice ahead of Central and Waterloo & City line strike",
                                        "https://tfl.gov.uk/info-for/media/press-releases/2017/february/advice-ahead-of-central-and-waterloo-and-city-line-strike"),
        Tfl::Scraping::PressRelease.new("Northern Line Extension tunnelling machines in place",
                                        "https://tfl.gov.uk/info-for/media/press-releases/2017/february/huge-crane-lifts-northern-line-extension-tunnelling-giants-20-metres-below-ground"),
        Tfl::Scraping::PressRelease.new("Record-breaking year for Santander Cycles",
                                        "https://tfl.gov.uk/info-for/media/press-releases/2017/february/record-breaking-year-for-santander-cycles"),
        Tfl::Scraping::PressRelease.new("Lambeth North re-opens following installation of new lifts",
                                        "https://tfl.gov.uk/info-for/media/press-releases/2017/february/lambeth-north-re-opens-following-installation-of-new-lifts"),
        Tfl::Scraping::PressRelease.new("New raised platforms improve accessible travel",
                                        "https://tfl.gov.uk/info-for/media/press-releases/2017/february/new-raised-platforms-improve-accessible-travel"),
        Tfl::Scraping::PressRelease.new("Tottenham Court Road becomes step-free",
                                        "https://tfl.gov.uk/info-for/media/press-releases/2017/february/tottenham-court-road-becomes-step-free"),
        Tfl::Scraping::PressRelease.new("Bakerloo line extension to support new housing and jobs",
                                        "https://tfl.gov.uk/info-for/media/press-releases/2017/february/bakerloo-line-extension-to-support-new-housing-and-jo"),
        Tfl::Scraping::PressRelease.new("Travel advice ahead of planned RMT Tube strike",
                                        "https://tfl.gov.uk/info-for/media/press-releases/2017/february/travel-advice-ahead-of-planned-tube-strike-action"),
      ])
    end
    # rubocop:enable Metrics/LineLength

    # rubocop:disable Metrics/LineLength
    it "returns a list of strike-related press releases" do
      expect(instance.strikes).to match_array([
        Tfl::Scraping::PressRelease.new("Travel advice for customers during today's strike",
                                        "https://tfl.gov.uk/info-for/media/press-releases/2017/february/travel-advice-for-customers-during-today-s-strike"),
        Tfl::Scraping::PressRelease.new("Advice ahead of Central and Waterloo & City line strike",
                                        "https://tfl.gov.uk/info-for/media/press-releases/2017/february/advice-ahead-of-central-and-waterloo-and-city-line-strike"),
        Tfl::Scraping::PressRelease.new("Travel advice ahead of planned RMT Tube strike",
                                        "https://tfl.gov.uk/info-for/media/press-releases/2017/february/travel-advice-ahead-of-planned-tube-strike-action"),
      ])
    end
    # rubocop:enable Metrics/LineLength
  end
end
