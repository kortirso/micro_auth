# frozen_string_literal: true

channel = RabbitMq.consumer_channel
queue = channel.queue('auth', durable: true)

queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
  payload = JSON.parse(payload)
  service = Auth::FetchUserService.call(token: payload.fetch('token'))

  client = AdsService::RpcClient.fetch
  client.send_user_id(
    service.success? ? service.result.id : nil,
    properties[:message_id]
  )

  channel.ack(delivery_info.delivery_tag)
end
