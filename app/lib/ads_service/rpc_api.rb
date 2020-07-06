# frozen_string_literal: true

require 'securerandom'

module AdsService
  module RpcApi
    def send_user_id(user_id, reply_message_id)
      payload = { user_id: user_id }.to_json
      publish(payload, type: 'send_user_id', reply_message_id: reply_message_id)
    end
  end
end
