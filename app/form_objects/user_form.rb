# frozen_string_literal: true

class UserForm < Dry::Struct
  include BCrypt

  PASSWORD_MINIMUM_SIZE = 8

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
    return false unless password_is_valid?(attributes[:password])

    attributes[:password_digest] = Password.create(attributes[:password]) if attributes[:password]
    attributes[:id] ? update(attributes) : create(attributes)
  end

  private

  def password_is_valid?(password)
    return true if password.nil?
    return true if password.size >= PASSWORD_MINIMUM_SIZE

    @errors = 'Password is too short, must be at least 8 characters'
    false
  end

  def create(attributes)
    schema = UserCreateContract.new.call(attributes)
    return false unless schema_is_valid?(schema)

    @user = User.new
    user.set(attributes.except(:id, :password))
    user.save
  end

  def update(attributes)
    schema = UserUpdateContract.new.call(attributes)
    return false unless schema_is_valid?(schema)

    @user = User.first(id: attributes[:id])
    user.update(attributes.except(:id, :password, :email))
  end

  def schema_is_valid?(schema)
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
