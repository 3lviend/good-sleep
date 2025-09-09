FactoryBot.define do
  factory :daily_sleep_summary do
    association :user
    date                 { Time.current }
    total_sleep_duration { 8 * 3600 } # 8 hours in seconds
    sleep_quality_score  { 1 }
  end
end

# == Schema Information
#
# Table name: daily_sleep_summaries
#
#  id                   :bigint           not null, primary key
#  date                 :date
#  sleep_quality_score  :integer          default(0)
#  total_sleep_duration :integer          default(0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :bigint           not null
#
# Indexes
#
#  index_daily_sleep_summaries_on_date              (date)
#  index_daily_sleep_summaries_on_user_id           (user_id)
#  index_daily_sleep_summaries_on_user_id_and_date  (user_id,date) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
