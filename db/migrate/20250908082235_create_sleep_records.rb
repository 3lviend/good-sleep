class CreateSleepRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :sleep_records do |t|
      t.datetime   :sleep_time, null: false, index: true
      t.datetime   :awake_time, index: true
      t.integer    :duration_seconds, null: false, index: true, default: 0
      t.belongs_to :user, null: false, foreign_key: true, index: true

      t.timestamps
    end

    add_index :sleep_records, [ :user_id, :created_at ]

    # Optimizes queries filtering by user and sleep time, and sorting by sleep time.
    add_index :sleep_records, [:user_id, :sleep_time]

    # Optimizes queries filtering by user and awake time.
    add_index :sleep_records, [:user_id, :awake_time]

    # Optimizes queries filtering by user and sleep duration.
    add_index :sleep_records, [:user_id, :duration_seconds]

    # Partial index for the 'sleeping' scope (awake_time is NULL).
    add_index :sleep_records, :sleep_time, where: "awake_time IS NULL", name: "index_sleep_records_on_sleep_time_for_sleeping"
  end
end
