# frozen_string_literal: true

module Users
  class CreateContract < BasicContract
    schema do
      required(:name).filled(:string)
      required(:email).filled(:string)
      required(:password).filled(:string)
    end

    rule(:email) do
      key.failure(:is_exist) if User.first(email: values[:email])
    end

    rule(:password) do
      key.failure(:is_too_short) if values[:password].size < User::PASSWORD_MINIMUM_SIZE
    end
  end
end
