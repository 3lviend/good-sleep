FactoryBot.define do
  factory :sleep_record do
    association :user

    sleep_time       { Faker::Time.backward(days: 1, period: :night) }
    awake_time       { Faker::Time.forward(days: 1, period: :morning) }
    duration_seconds { ((awake_time || Time.current) - sleep_time).to_i }

    trait :sleeping do
      awake_time { nil }
      duration_seconds { 0 }
    end
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
#  index_sleep_records_on_awake_time              (awake_time)
#  index_sleep_records_on_duration_seconds        (duration_seconds)
#  index_sleep_records_on_sleep_time              (sleep_time)
#  index_sleep_records_on_user_id                 (user_id)
#  index_sleep_records_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
