# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define() do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "user_sessions", id: :bigint, default: nil, force: :cascade do |t|
    t.text "uuid", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, default: -> { "now()" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "now()" }, null: false
    t.index ["user_id"], name: "user_sessions_user_id_index"
    t.index ["uuid"], name: "user_sessions_uuid_key", unique: true
  end

  create_table "users", id: :bigint, default: nil, force: :cascade do |t|
    t.text "name", null: false
    t.text "password_digest", null: false
    t.text "email", null: false
    t.datetime "created_at", precision: 6, default: -> { "now()" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "now()" }, null: false
    t.index ["email"], name: "users_email_key", unique: true
  end

end
