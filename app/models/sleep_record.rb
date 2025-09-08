class SleepRecord < ApplicationRecord
  # == Associations
  belongs_to :user

  # == Validations
  validates :sleep_time, presence: true
  validates :awake_time, comparison: { greater_than: :sleep_time }, allow_nil: true
  validates :duration_seconds, presence: true, unless: :sleeping?
  validates :duration_seconds, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, unless: :sleeping?

  # == Scopes
  scope :longest, -> { order(duration_seconds: :desc) }
  scope :shortest, -> { order(duration_seconds: :asc) }
  scope :sleeping, -> { where(awake_time: nil) }

  # == Instance Methods

  def sleeping?
    awake_time.nil?
  end

  def sleep_duration(duration_type = :second)
    return nil if sleeping?

    case duration_type
    when :hour
      (duration_seconds / 3600.0).round(2)
    when :minute
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
end

# == Schema Information
#
# Table name: sleep_records
#
#  id               :bigint           not null, primary key
#  awake_time       :datetime
#  duration_seconds :integer
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
