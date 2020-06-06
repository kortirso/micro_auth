# frozen_string_literal: true

class UserForm < Dry::Struct
  include BCrypt

  module Types
    include Dry::Types(default: :nominal)
  end

  attribute :id, Types::Integer.optional
  attribute :email, Types::String
  attribute :name, Types::String
  attribute :password, Types::String.optional

  attr_reader :user, :errors

  def save
    attributes = to_hash
    attributes[:password_digest] = Password.create(attributes[:password]) if attributes[:password]
    attributes[:id] ? update(attributes) : create(attributes)
  end

  private

  def create(attributes)
    schema = UserCreateContract.new.call(attributes)
    return false unless is_valid?(schema)

    @user = User.new
    user.set(attributes.except(:id, :password))
    user.save
  end

  def update(attributes)
    schema = UserUpdateContract.new.call(attributes)
    return false unless is_valid?(schema)

    @user = User.first(id: attributes[:id])
    user.update(attributes.except(:id, :password, :email))
  end

  def is_valid?(schema)
    @errors = schema.errors(locale: I18n.locale).to_h.values.flatten
    return true if errors.empty?

    false
  end
end

class UserCreateContract < Dry::Validation::Contract
  config.messages.namespace = :user
  config.messages.load_paths << 'config/locales/en.yml'
  config.messages.load_paths << 'config/locales/ru.yml'

  schema do
    required(:name).filled(:string)
    required(:email).filled(:string)
    required(:password_digest).filled(:string)
  end

  rule(:email) do
    key.failure(I18n.t('dry_validation.errors.user.is_exist')) if User.first(email: values[:email])
  end
end

class UserUpdateContract < Dry::Validation::Contract
  config.messages.namespace = :user
  config.messages.load_paths << 'config/locales/en.yml'
  config.messages.load_paths << 'config/locales/ru.yml'

  schema do
    required(:id)
    optional(:name).filled(:string)
    optional(:password_digest).filled(:string)
  end
end
