# frozen_string_literal: true

module Users
  class CreateService
    prepend BasicService

    param :name
    param :email
    param :password

    attr_reader :user

    def call
      contract = Users::CreateContract.new
      errors = contract.call(user_attributes).errors.to_h
      return fail!(errors) if errors.size.positive?

      @user = User.create(user_attributes)
    end

    private

    def user_attributes
      @user_attributes ||=
        {
          name:     @name,
          email:    @email,
          password: @password
        }.compact
    end
  end
end
