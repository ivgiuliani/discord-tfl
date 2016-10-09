# frozen_string_literal: true

require "yaml"

module Bot
  module DefaultConfig
    PREFIX = "!"
    USERNAME = "TfLBot"
  end

  class Config
    def load_config(config_file)
      return if config_loaded

      cfg = YAML.load_file(config_file)

      @prefix = config(cfg, "command_prefix", prefix)
      @username = config(cfg, "username", username)

      @config_loaded = true
    end

    def config_loaded
      @config_loaded ||= false
    end

    def prefix
      @prefix ||= DefaultConfig::PREFIX
    end

    def username
      @username ||= DefaultConfig::USERNAME
    end

    private

    def config(cfg, key, default)
      if cfg.key?(key) && !cfg[key].nil?
        cfg[key]
      else
        default
      end
    end
  end
end
