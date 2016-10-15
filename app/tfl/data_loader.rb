# frozen_string_literal: true

module Tfl
  module DataLoader
    def data_file_path(name)
      base = "#{File.dirname(__FILE__)}/data"
      File.join(base, name)
    end

    def inject_from_json(json_name)
      content = File.read(data_file_path("#{json_name}.json"))
      JSON.parse(content).map do |item|
        item["id"]
      end
    end
  end
end
