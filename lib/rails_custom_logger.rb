# frozen_string_literal: true

require 'json'

require_relative 'rails_custom_logger/version'

module RailsCustomLogger
  class JsonFormatter
    if defined?(::Rails)
      include ActiveSupport::TaggedLogging::Formatter
    end

    def call(severity, timestamp, progname, msg)
      message = {
        timestamp: timestamp.utc.strftime('%Y-%m-%dT%H:%M:%S.%L%:z'),
        level: severity,
        progname: progname,
        message: msg,
        **build_context
      }
      "#{JSON.dump(message)}\n"
    end

    private

    def build_context
      return {} unless defined?(::Rails)

      request_id = nil

      current_tags.each do |tag|
        if tag.match?(/\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/)
          request_id = tag
        end
      end

      request_id = Thread.current.object_id if request_id.nil?

      { request_id: request_id, tags: current_tags }
    end
  end
end
