# frozen_string_literal: true

module Users
  class CreateService
    prepend BasicService

    param :name
    param :email
    param :password

    attr_reader :user

    def call
      user_form = UserForm.new(
        id:       nil,
        name:     @name,
        email:    @email,
        password: @password
      )

      fail!(user_form.errors) unless user_form.save
      @user = user_form.user
    end
  end
end
