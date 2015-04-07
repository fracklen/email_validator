require 'bunny'

module AMQP
  class Client
    attr_reader :exchange, :channel

    def initialize(url)
      @url = url
      @exchange = nil
    end

    def publish(msg, options)
      reconnect! if exchange.nil?
      exchange.publish(msg, options)
    rescue Bunny::TCPConnectionFailed => e
      # If disconnected, airbrake, reconnect and retry once
      Airbrake.notify(e)
      reconnect!
      exchange.publish(msg, options)
    end

    def subscribe(queue, routing_keys, options = {}, &block)
      reconnect! if exchange.nil?
      fail 'No active channel' if channel.nil?

      q = channel.queue(queue)

      routing_keys.each do |routing_key|
        q.bind(exchange, routing_key: routing_key)
      end

      q.subscribe(options, &block)
    end

    def close!
      channel.close unless channel.nil?
      @channel = nil
      @exchange = nil
    end

    private

    def reconnect!
      @channel  = conn.create_channel
      @exchange = channel.topic('lb', auto_delete: false, durable: true)
    rescue Bunny::TCPConnectionFailed => e
      Airbrake.notify(e)
      close!
    end

    def conn
      @conn ||= Bunny.new(@url).tap(&:start)
    end
  end
end
