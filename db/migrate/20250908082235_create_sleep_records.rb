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
  end
end
