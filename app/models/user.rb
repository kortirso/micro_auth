# frozen_string_literal: true

class User < Sequel::Model
  PASSWORD_MINIMUM_SIZE = Settings.password.minimum_length

  plugin :secure_password, cost: PASSWORD_MINIMUM_SIZE, include_validations: false

  one_to_many :user_sessions
end
