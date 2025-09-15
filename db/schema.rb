# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

# NOTE: The following indexes have been added to the sleep_records table to address
# potential performance issues with full-table scans:
#   - index_sleep_records_on_awake_time
#   - index_sleep_records_on_duration_seconds
#   - index_sleep_records_on_sleep_time
#   - index_sleep_records_on_user_id_and_awake_time
#   - index_sleep_records_on_user_id_and_sleep_time

ActiveRecord::Schema[8.0].define(version: 2025_09_12_021505) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "daily_sleep_summaries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "date"
    t.integer "total_sleep_duration", default: 0
    t.integer "sleep_quality_score", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_daily_sleep_summaries_on_date"
    t.index ["user_id", "date"], name: "index_daily_sleep_summaries_on_user_id_and_date", unique: true
    t.index ["user_id"], name: "index_daily_sleep_summaries_on_user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.bigint "followed_id", null: false
    t.bigint "follower_id", null: false
    t.boolean "blocked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blocked"], name: "index_follows_on_blocked"
    t.index ["followed_id", "follower_id"], name: "index_follows_on_followed_id_and_follower_id", unique: true
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "sleep_records", force: :cascade do |t|
    t.datetime "sleep_time", null: false
    t.datetime "awake_time"
    t.integer "duration_seconds", default: 0, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["awake_time"], name: "index_sleep_records_on_awake_time"
    t.index ["duration_seconds"], name: "index_sleep_records_on_duration_seconds"
    t.index ["sleep_time"], name: "index_sleep_records_for_sleeping", where: "(awake_time IS NULL)"
    t.index ["sleep_time"], name: "index_sleep_records_on_sleep_time"
    t.index ["user_id", "awake_time"], name: "index_sleep_records_on_user_id_and_awake_time"
    t.index ["user_id", "created_at"], name: "index_sleep_records_on_user_id_and_created_at"
    t.index ["user_id", "duration_seconds"], name: "index_sleep_records_on_user_id_and_duration_seconds"
    t.index ["user_id", "sleep_time"], name: "index_sleep_records_on_user_id_and_sleep_time"
    t.index ["user_id"], name: "index_sleep_records_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_users_on_name"
  end

  add_foreign_key "daily_sleep_summaries", "users"
  add_foreign_key "follows", "users", column: "followed_id"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "sleep_records", "users"
end
