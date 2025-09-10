class UserFollowSerializer < ActiveModel::Serializer
  attributes :id, :name
  attributes :sleep_records
  attributes :created_at

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
# Table name: users
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_name  (name)
#
