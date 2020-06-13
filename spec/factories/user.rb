# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email-#{n}@example.com" }
    sequence(:name) { |n| "Name_#{n}" }
    password { 'givemeatoken' }
  end
end
