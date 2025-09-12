class SleepRecord < ApplicationRecord
  # == Associations
  belongs_to :user

  # == Validations
  validates :sleep_time, presence: true
  validates :awake_time, comparison: { greater_than: :sleep_time }, allow_nil: true
  validates :duration_seconds, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, unless: :sleeping?

  # == Scopes
  scope :short_sleep,     -> { where("duration_seconds < ?", 7 * 3600) }
  scope :well_sleep,      -> { where(duration_seconds: (7 * 3600)..(9 * 3600)) }
  scope :over_sleep,      -> { where("duration_seconds > ?", 9 * 3600) }
  scope :longest,         -> { order(duration_seconds: :desc) }
  scope :shortest,        -> { order(duration_seconds: :asc) }
  scope :sleeping,        -> { order(sleep_time: :desc).where(awake_time: nil) }
  scope :order_by_newest, -> { order(sleep_time: :desc) }
  scope :sleep_time_between, ->(start_time, end_time) {
    where(sleep_time: start_time..end_time)
  }
  scope :awake_time_between, ->(start_time, end_time) {
    where(awake_time: start_time..end_time)
  }
  scope :duration_seconds_between, ->(start_time, end_time) {
    where(duration_seconds: start_time..end_time)
  }

  # == Callbacks
  before_validation :set_sleep_duration, on: :update

  # == Pagination
  paginates_per 10

  # == Instance Methods

  def sleeping?
    awake_time.nil?
  end

  def sleep_duration(duration_type = :second)
    return nil if sleeping?

    case duration_type
    when :hour
      # Convert seconds to hours and round to 2 decimal places
      (duration_seconds / 3600.0).round(2)
    when :minute
      # Convert seconds to minutes and round to 2 decimal places
      (duration_seconds / 60.0).round(2)
    else
      duration_seconds
    end
  end

  def wakeup!
    return awake_time unless sleeping?

    now      = Time.current
    duration = now - sleep_time
    update!(awake_time: now, duration_seconds: duration.to_i)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id sleep_time awake_time duration_seconds]
  end

  def self.ransackable_scopes(_auth_object = nil)
    %w[sleep_time_between awake_time_between duration_seconds_between]
  end

  private

  def set_sleep_duration
    return 0 if sleeping?

    self.duration_seconds = (awake_time - sleep_time).to_i
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
