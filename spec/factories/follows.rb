FactoryBot.define do
  factory :follow do
    association :follower, factory: :user
    association :followed, factory: :user

    trait :blocked do
      blocked { true }
    end
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
