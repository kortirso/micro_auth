# frozen_string_literal: true

module Users
  class CreateService
    prepend BasicService

    option :user do
      option :name
      option :email
      option :password
    end

    attr_reader :result

    def call
      validate_with(Users::CreateContract, @user.to_h)
      @result = ::User.create(@user.to_h) if errors.blank?
    end
  end
end
