# frozen_string_literal: true

require "yaml"

module Bot
  module Config
    module Default
      PREFIX = "!"
      USERNAME = "TfLBot"
    end

    def load_config(config_file)
      return if config_loaded

      cfg = YAML.load_file(config_file)

      @cfg_prefix = config(cfg, "command_prefix", cfg_prefix)
      @cfg_username = config(cfg, "username", cfg_username)

      @config_loaded = true
    end

    def config_loaded
      @config_loaded ||= false
    end

    def cfg_prefix
      @cfg_prefix ||= Default::PREFIX
    end

    def cfg_username
      @cfg_username ||= Default::USERNAME
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
