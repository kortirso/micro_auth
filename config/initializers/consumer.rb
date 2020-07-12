# frozen_string_literal: true

channel = RabbitMq.consumer_channel
exchange = channel.default_exchange
queue = channel.queue('auth', durable: true)

queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
  Thread.current[:request_id] = properties.headers['request_id']

  payload = JSON.parse(payload)

  service = Auth::FetchUserService.call(token: payload.fetch('token'))
  user_id = service.success? ? service.result.id : nil
  publish_payload = { user_id: user_id }.to_json

  Application.logger.info(
    'verified token',
    token:   payload.fetch('token'),
    user_id: user_id
  )

  exchange.publish(
    publish_payload,
    routing_key:    properties.reply_to,
    correlation_id: properties.correlation_id
  )

  channel.ack(delivery_info.delivery_tag)
end
