class SleepRecordSerializer < ActiveModel::Serializer
  attributes :id, :sleep_time, :awake_time, :duration_seconds
  attributes :sleep_duration
  attributes :user
  attributes :created_at

  def user
    UserSerializer.new(object.user, root: false, include_followable_summaries: false).as_json
  end

  def sleep_duration
    {
      hour: object.sleep_duration(:hour),
      minute: object.sleep_duration(:minute),
      second: object.sleep_duration(:second)
    }
  end
end

# == Schema Information
#
# Table name: sleep_records
#
#  id               :bigint           not null, primary key
#  awake_time       :datetime
#  duration_seconds :integer          default(0), not null
#  sleep_time       :datetime         not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_sleep_records_for_sleeping                     (sleep_time) WHERE (awake_time IS NULL)
#  index_sleep_records_on_awake_time                    (awake_time)
#  index_sleep_records_on_duration_seconds              (duration_seconds)
#  index_sleep_records_on_sleep_time                    (sleep_time)
#  index_sleep_records_on_user_id                       (user_id)
#  index_sleep_records_on_user_id_and_awake_time        (user_id,awake_time)
#  index_sleep_records_on_user_id_and_created_at        (user_id,created_at)
#  index_sleep_records_on_user_id_and_duration_seconds  (user_id,duration_seconds)
#  index_sleep_records_on_user_id_and_sleep_time        (user_id,sleep_time)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
