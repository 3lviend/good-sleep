class CreateFollows < ActiveRecord::Migration[8.0]
  def change
    create_table :follows, force: true do |t|
      t.belongs_to :followed, null: false, index: true, foreign_key: { to_table: :users }
      t.belongs_to :follower, null: false, index: true, foreign_key: { to_table: :users }
      t.boolean    :blocked, default: false, null: false, index: true
      t.timestamps
    end
    add_index :follows, [ "followed_id", "follower_id" ], unique: true
  end
end
