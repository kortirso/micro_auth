# frozen_string_literal: true

module UserSessions
  class CreateService
    prepend BasicService

    option :email
    option :password
    option :user, default: proc { User.first(email: @email) }, reader: false

    attr_reader :result

    def call
      validate
      create_session unless failure?
    end

    private

    def validate
      fail!('Unauthorized') unless @user&.authenticate(@password)
    end

    def create_session
      @result = UserSession.create user: @user
    end
  end
end
