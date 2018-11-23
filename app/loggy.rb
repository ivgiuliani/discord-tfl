# frozen_string_literal: true

require "logger"
require "prius"

Prius.load(:tflbot_logging_level, required: false)

# rubocop:disable Style/ClassVars
module Loggy
  LOG_MAP = {
    error: Logger::ERROR,
    warn: Logger::WARN,
    info: Logger::INFO,
    debug: Logger::DEBUG,
  }.freeze

  @@logger = nil

  def logger
    if @@logger.nil?
      $stdout.sync = true
      @@logger = Logger.new(STDOUT)

      @@logger.level = log_status
      @@logger.formatter = formatter

      debug "WARNING: Debug logging is enabled!"
    end

    @@logger
  end

  def info(message)
    logger.info(message)
  end

  def debug(message)
    logger.debug(message)
  end

  def warn(message)
    logger.warn(message)
  end

  def error(message)
    logger.error(message)
  end

  def fatal(message)
    logger.fatal(message)
  end

  alias_method :log, :info

  private

  def formatter
    proc do |severity, datetime, _progname, msg|
      "#{severity} | #{datetime}: #{msg}\n"
    end
  end

  def log_status
    LOG_MAP[(Prius.get(:tflbot_logging_level) || "info").downcase.to_sym]
  end
end
# rubocop:enable Style/ClassVars
