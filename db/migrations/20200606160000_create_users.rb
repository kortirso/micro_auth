# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id, type: :Bignum

      String :name, unique: false, null: false, fixed: true
      String :password_digest, unique: false, null: false, fixed: true
      String :email, unique: true, null: false, fixed: true

      column :created_at, 'timestamp(6) without time zone', null: false, default: Sequel.lit('now()')
      column :updated_at, 'timestamp(6) without time zone', null: false, default: Sequel.lit('now()')
    end
  end

  down do
    drop_table(:users, cascade: true)
  end
end
