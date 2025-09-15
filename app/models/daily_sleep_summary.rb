class DailySleepSummary < ApplicationRecord
  # == Modules
  include DurationConverter

  # == Associations
  belongs_to :user

  # == Validations
  validates :date, presence: true
  validates :total_sleep_duration, numericality: { greater_than_or_equal_to: 0 }

  # == Callbacks
  before_validation :set_sleep_quality_score

  # == Scopes
  scope :last_month, -> { where(date: 1.month.ago.to_datetime.beginning_of_day..Time.current.end_of_day) }

  # == Instance Methods

  def sleep_duration(duration_type = :second)
    convert_duration(total_sleep_duration, duration_type)
  end

  private

  def set_sleep_quality_score
    self.sleep_quality_score = case sleep_duration(:hour)
    when 6...8
      # when sleep duration is between 6 to 8 hours sleep quality score is 10
      10
    when 4...6, 9...12
      # when sleep duration is between 4 to 6 hours or 9 to 12 hours sleep quality score is 8
      8
    else
      # otherwise sleep quality score is 5
      5
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
