require 'rails_helper'

RSpec.describe Follow, type: :model do
  before do
    @user1 = create(:user)
    @user2 = create(:user)
    @user3 = create(:user)
  end

  it "should belong to follower and followed" do
    follow = create(:follow, follower: @user1, followed: @user2)
    expect(follow.follower).to eq(@user1)
    expect(follow.followed).to eq(@user2)
  end

  it "should not be valid without follower_id" do
    follow = build(:follow, follower: nil, followed: @user2)
    expect(follow).not_to be_valid
    expect(follow.errors[:follower_id]).to include("can't be blank")
  end

  it "should not be valid without followed_id" do
    follow = build(:follow, follower: @user1, followed: nil)
    expect(follow).not_to be_valid
    expect(follow.errors[:followed_id]).to include("can't be blank")
  end

  it "should not allow a user to follow themselves" do
    follow = build(:follow, follower: @user1, followed: @user1)
    expect(follow).not_to be_valid
    expect(follow.errors[:follower_id]).to include("cannot follow yourself")
  end

  it "should not allow duplicate follows" do
    create(:follow, follower: @user1, followed: @user2)
    duplicate_follow = build(:follow, follower: @user1, followed: @user2)
    expect(duplicate_follow).not_to be_valid
    expect(duplicate_follow.errors[:follower_id]).to include("is already following this user")
  end

  it "should be valid with unique follower and followed" do
    follow = build(:follow, follower: @user1, followed: @user2)
    expect(follow).to be_valid
  end

  it "blocked scope should return blocked follows" do
    create(:follow, follower: @user1, followed: @user2, blocked: true)
    create(:follow, follower: @user1, followed: @user3, blocked: false)

    expect(Follow.blocked.count).to eq(1)
    expect(Follow.blocked.first.followed).to eq(@user2)
  end

  it "not_blocked scope should return non-blocked follows" do
    create(:follow, follower: @user1, followed: @user2, blocked: true)
    create(:follow, follower: @user1, followed: @user3, blocked: false)

    expect(Follow.not_blocked.count).to eq(1)
    expect(Follow.not_blocked.first.followed).to eq(@user3)
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
