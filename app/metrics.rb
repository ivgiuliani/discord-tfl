# frozen_string_literal: true

require "prometheus/client"

module Metrics
  SERVICE_NAME = "tflbot"

  class << self
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
  end
end
