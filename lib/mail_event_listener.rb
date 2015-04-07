require 'json'
require 'uri'

module AMQP
  class MailEventListener
    ROUTING_KEYS = %w(mail.*.failed mail.*.bounced)

    class << self
      def listen
        new(AMQP::Client.new(ENV['RABBITMQ_URL'])).listen
      end
    end

    def initialize(client)
      @client = client
    end

    def listen
      @client.subscribe('email_validator', ROUTING_KEYS, block: true) do |delivery_info, properties, payload|
        write_event(payload, properties)
      end
    end

    def write_event(event, properties)
      event_data = JSON.parse(event)

      email = URI.escape(event_data['data']['to'])

      event_data['event_type'] = properties[:type]

      CouchClient.put do |req|
        req.url "/email_addresses_rejected/#{email}"
        req.headers['Content-Type'] = 'application/json'
        req.body = event_data.to_json
      end
    end
  end
end
