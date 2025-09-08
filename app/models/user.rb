class User < ApplicationRecord

  # == Modules
  # acts_as_followable
  # acts_as_follower

  # == Associations
  has_many :sleep_records, dependent: :destroy

  # == Validations
  validates :name, presence: true, uniqueness: true
  validates :name, length: { maximum: 50 }

  # == Instance Methods

  def current_sleep_record
    sleep_records.sleeping.first
  end

  def go_sleep(sleep_time = Time.current)
    #  Clock-in a new sleep record if user not already sleeping
    return current_sleep_record if sleep_records.sleeping.exists?

    create(sleep_time: sleep_time, awake_time: nil, duration_seconds: nil)
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
