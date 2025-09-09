class User < ApplicationRecord
  # == Modules
  # acts_as_followable
  # acts_as_follower

  # == Associations
  has_many :sleep_records, dependent: :destroy
  has_many :daily_sleep_summaries, dependent: :destroy

  # == Validations
  validates :name, presence: true, uniqueness: true
  validates :name, length: { maximum: 50 }

  # == Callbacks
  after_save    :clear_cache
  after_destroy :clear_cache

  # == Instance Methods

  def current_sleep_record
    sleep_records.sleeping.first
  end

  def self.ransackable_attributes(_auth_object = nil)
    %i[id name]
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
