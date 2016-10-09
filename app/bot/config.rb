# frozen_string_literal: true

require "yaml"

module Bot
  module Config
    module Default
      PREFIX = "!"
      USERNAME = "TfLBot"
    end

    def load_config(config_file)
      cfg = YAML.load_file(config_file)

      @cfg_prefix = config(cfg, "command_prefix", cfg_prefix)
      @cfg_username = config(cfg, "username", cfg_username)
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
