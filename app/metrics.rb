# frozen_string_literal: true

require "prometheus/client"

module Metrics
  SERVICE_NAME = "tflbot"

  class << self
    def now_monotonic
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    def counter(name:,
                desc:,
                labels: [])
      Prometheus::Client.registry.counter(
        :"#{SERVICE_NAME}_#{name}_total",
        docstring: desc,
        labels: labels,
      )
    end

    def gauge(name:,
              desc:,
              labels: [])
      Prometheus::Client.registry.gauge(
        :"#{SERVICE_NAME}_#{name}",
        docstring: desc,
        labels: labels,
      )
    end

    def duration(metric_counter, metric_duration, labels = {})
      start_time = now_monotonic
      yield
    ensure
      elapsed = [now_monotonic - start_time, 0].max

      metric_counter.increment(labels: labels)
      metric_duration.increment(by: elapsed, labels: labels)
    end
  end
end
