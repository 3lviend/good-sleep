class DailySleepSummary < ApplicationRecord
  # == Associations
  belongs_to :user

  # == Validations
  validates :date, presence: true
  validates :total_sleep_duration, numericality: { greater_than_or_equal_to: 0 }

  # == Instance Methods

  def sleep_duration(duration_type = :second)
    case duration_type
    when :hour
      # Convert seconds to hours and round to 2 decimal places
      (total_sleep_duration / 3600.0).round(2)
    when :minute
      # Convert seconds to minutes and round to 2 decimal places
      (total_sleep_duration / 60.0).round(2)
    else
      total_sleep_duration
    end
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
