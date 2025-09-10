class User < ApplicationRecord
  # == Associations
  has_many :sleep_records, dependent: :destroy
  has_many :daily_sleep_summaries, dependent: :destroy
  has_many :all_following_relationship, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :all_follower_relationship, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  has_many :following_relationship, -> { where(blocked: false) }, class_name: "Follow", foreign_key: "follower_id"
  has_many :followers_relationship, -> { where(blocked: false) }, class_name: "Follow", foreign_key: "followed_id"
  has_many :blocked_relationship, -> { where(blocked: true) }, class_name: "Follow", foreign_key: "followed_id"
  has_many :following, through: :following_relationship, source: :followed
  has_many :followers, through: :followers_relationship, source: :follower
  has_many :blocked, through: :blocked_relationship, source: :follower

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

  def following?(other_user)
    return unless other_user.is_a?(self.class)

    following_relationship.exists?(followed_id: other_user.id)
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
