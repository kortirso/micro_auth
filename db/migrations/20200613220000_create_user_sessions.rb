# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:user_sessions) do
      primary_key :id, type: :Bignum

      String :uuid, unique: true, null: false
      Integer :user_id, unique: false, null: false

      column :created_at, 'timestamp(6) without time zone', null: false, default: Sequel.lit('now()')
      column :updated_at, 'timestamp(6) without time zone', null: false, default: Sequel.lit('now()')

      index [:user_id]
    end
  end

  down do
    drop_table(:user_sessions, cascade: true)
  end
end
