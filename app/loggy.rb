# frozen_string_literal: true
require "logger"

module Loggy
  def logger
    if @logger.nil?
      $stdout.sync = true
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO

      @logger.formatter = proc do |severity, datetime, _progname, msg|
        "#{severity} | #{datetime}: #{msg}"
      end
    end

    @logger
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
end
