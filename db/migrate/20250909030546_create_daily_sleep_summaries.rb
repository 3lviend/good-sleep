class CreateDailySleepSummaries < ActiveRecord::Migration[8.0]
  def change
    create_table :daily_sleep_summaries do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date, index: true
      t.integer :total_sleep_duration, default: 0
      t.integer :sleep_quality_score, default: 0

      t.timestamps
    end

    add_index :daily_sleep_summaries, [ :user_id, :date ], unique: true, name: 'index_daily_sleep_summaries_on_user_id_and_date'
  end
end
