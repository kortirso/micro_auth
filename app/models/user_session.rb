# frozen_string_literal: true

class UserSession < Sequel::Model
  many_to_one :user

  def before_save
    super
    self.uuid = SecureRandom.uuid
  end
end
