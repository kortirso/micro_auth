# frozen_string_literal: true

require 'bcrypt'

namespace :db do
  desc 'Seed database'
  task seed: [:settings] do |_t, _args|
    require 'sequel/core'

    Sequel.connect(Settings.db.to_hash) do |db|
      users = db.from(:users)

      JSON.parse(File.read("#{Dir.pwd}/db/seeds/users.json")).each do |user|
        users.insert(
          email:           user.fetch('email'),
          name:            user.fetch('name'),
          password_digest: BCrypt::Password.create(user.fetch('password'))
        )
      end

      puts '*** db:seed executed ***'
    end
  end
end
