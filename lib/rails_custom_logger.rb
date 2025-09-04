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
        time: timestamp.utc.strftime('%Y-%m-%dT%H:%M:%S.%6N%:z'),
        level: severity,
        progname: progname,
        message: sanitize_value!(msg),
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

    def sanitize_value!(obj)
      return obj unless obj.is_a?(String)
      # если уже валидная UTF-8 строка — ничего не делать
      return obj if obj.encoding == Encoding::UTF_8 && obj.valid_encoding?

      if obj.frozen?
        obj.encode('UTF-8', invalid: :replace, undef: :replace, replace: '�')
      else
        obj.encode!('UTF-8', invalid: :replace, undef: :replace, replace: '�')
      end
    end
  end
end
