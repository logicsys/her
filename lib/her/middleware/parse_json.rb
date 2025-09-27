module Her
  module Middleware
    class ParseJSON < Faraday::Middleware

      # @private
      def call(env)
        @app.call(env).on_complete do |environment|
          on_complete(environment)
        end
      end

      # @private
      def on_complete(env)
        if env[:body]
          env[:body] = parse_json(env[:body])
        end
      end

      # @private
      def parse_json(body = nil)
        body = '{}' if body.blank?
        message = "Response from the API must behave like a Hash or an Array (last JSON response was #{body.inspect})"

        json = begin
          MultiJson.load(body, symbolize_keys: true)
        rescue MultiJson::LoadError
          raise Her::Errors::ParseError, message
        end

        raise Her::Errors::ParseError, message unless json.is_a?(Hash) || json.is_a?(Array)

        json
      end
    end
  end
end
