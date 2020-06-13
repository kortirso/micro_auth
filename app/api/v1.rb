# frozen_string_literal: true

module Api
  class V1 < Grape::API
    prefix 'api'
    version 'v1'
    format :json

    desc 'Returns the current API version'
    get do
      { version: 'v1' }
    end

    desc 'Creates user'
    params do
      build_with Grape::Extensions::Hash::ParamBuilder
      requires :user, type: Hash do
        requires :name,     type: String, desc: 'Name'
        requires :email,    type: String, desc: 'Email'
        requires :password, type: String, desc: 'Password'
      end
    end
    post 'users' do
      service = Users::CreateService.call(params)

      if service.success?
        { result: 'User is created' }
      else
        error!(ErrorSerializer.from_messages(service.errors), 400)
      end
    end

    desc 'Creates user session'
    params do
      build_with Grape::Extensions::Hash::ParamBuilder
      requires :email,    type: String, desc: 'Email'
      requires :password, type: String, desc: 'Password'
    end
    post 'sessions' do
      service = UserSessions::CreateService.call(params)

      if service.success?
        { token: JwtEncoder.encode(uuid: service.result.uuid) }
      else
        error!(ErrorSerializer.from_messages(service.errors), 400)
      end
    end
  end
end
