# frozen_string_literal: true

channel = RabbitMq.consumer_channel
exchange = channel.default_exchange
queue = channel.queue('auth', durable: true)

queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
  payload = JSON.parse(payload)

  service = Auth::FetchUserService.call(token: payload.fetch('token'))
  publish_payload = {
    user_id: (service.success? ? service.result.id : nil)
  }.to_json

  exchange.publish(
    publish_payload,
    routing_key:    properties[:reply_to],
    correlation_id: properties[:correlation_id]
  )

  channel.ack(delivery_info.delivery_tag)
end
