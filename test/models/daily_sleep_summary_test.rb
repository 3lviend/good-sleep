require "test_helper"

class DailySleepSummaryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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
