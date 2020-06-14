# frozen_string_literal: true

module Auth
  class FetchUserService
    prepend BasicService

    option :token

    attr_reader :result

    def call
      @uuid = extract_uuid
      fail!('Forbidden') if @uuid.blank? || session.blank?
      @result = session&.user
    end

    private

    def extract_uuid
      JwtEncoder.decode(@token)
    rescue JWT::DecodeError
      {}
    end

    def session
      @session ||= UserSession.first(uuid: @uuid.fetch('uuid', ''))
    end
  end
end
