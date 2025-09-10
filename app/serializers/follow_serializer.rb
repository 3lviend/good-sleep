class FollowSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at
  attributes :sleep_records

  def sleep_records
    records = object.sleep_records.longest.limit(10)

    data = ActiveModel::Serializer::CollectionSerializer.new(
      records,
      root: false,
      serializer: SleepRecordSerializer
    )

    data.map { |record| record.as_json.except(:user) }
  end
end

# == Schema Information
#
# Table name: follows
#
#  id          :bigint           not null, primary key
#  blocked     :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :bigint           not null
#  follower_id :bigint           not null
#
# Indexes
#
#  index_follows_on_blocked                      (blocked)
#  index_follows_on_followed_id                  (followed_id)
#  index_follows_on_followed_id_and_follower_id  (followed_id,follower_id)
#  index_follows_on_follower_id                  (follower_id)
#
