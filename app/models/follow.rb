class Follow < ActiveRecord::Base
  # == Associations
  belongs_to :followed, class_name: "User", foreign_key: "followed_id", inverse_of: :followers
  belongs_to :follower, class_name: "User", foreign_key: "follower_id", inverse_of: :followers

  # == Scopes
  scope :blocked, -> { where(blocked: true) }
  scope :not_blocked, -> { where(blocked: false) }

  # == Validations
  validates :followed_id, presence: true
  validates :follower_id, presence: true
  validates :follower_id, uniqueness: { scope: %i[followed_id follower_id],
                                        message: "is already following this user" }
  validate :cannot_follow_self

  # == Instance Methods

  private

  def cannot_follow_self
    errors.add(:follower_id, "cannot follow yourself") if followed_id == follower_id
  end
end

# == Schema Information
#
# Table name: follows
#
#  id          :bigint           not null, primary key
#  blocked     :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :bigint           not null
#  follower_id :bigint           not null
#
# Indexes
#
#  index_follows_on_blocked                      (blocked)
#  index_follows_on_followed_id                  (followed_id)
#  index_follows_on_followed_id_and_follower_id  (followed_id,follower_id) UNIQUE
#  index_follows_on_follower_id                  (follower_id)
#
# Foreign Keys
#
#  fk_rails_...  (followed_id => users.id)
#  fk_rails_...  (follower_id => users.id)
#
