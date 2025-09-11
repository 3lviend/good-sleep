require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = create(:user)
    @other_user = create(:user)
    @another_user = create(:user)
  end

  it "should be valid" do
    expect(@user).to be_valid
  end

  it "name should be present" do
    @user.name = ""
    expect(@user).not_to be_valid
    expect(@user.errors[:name]).to include("can't be blank")
  end

  it "name should be unique" do
    duplicate_user = @user.dup
    expect(duplicate_user).not_to be_valid
    expect(duplicate_user.errors[:name]).to include("has already been taken")
  end

  it "name should not be too long" do
    @user.name = "a" * 51
    expect(@user).not_to be_valid
    expect(@user.errors[:name]).to include("is too long (maximum is 50 characters)")
  end

  it "sleep_records association" do
    create_list(:sleep_record, 3, user: @user)
    expect(@user.sleep_records.count).to eq(3)
  end

  it "daily_sleep_summaries association" do
    create(:daily_sleep_summary, user: @user, date: 2.days.ago)
    create(:daily_sleep_summary, user: @user, date: 1.day.ago)
    expect(@user.daily_sleep_summaries.count).to eq(2)
  end

  it "following association" do
    create(:follow, follower: @user, followed: @other_user)
    expect(@user.following).to include(@other_user)
  end

  it "followers association" do
    create(:follow, follower: @other_user, followed: @user)
    expect(@user.followers).to include(@other_user)
  end

  it "blocked association" do
    create(:follow, follower: @other_user, followed: @user, blocked: true)
    expect(@user.blocked).to include(@other_user)
  end

  it "dependent destroy for sleep_records" do
    create_list(:sleep_record, 2, user: @user)
    expect { @user.destroy }.to change { SleepRecord.count }.by(-2)
  end

  it "dependent destroy for daily_sleep_summaries" do
    create(:daily_sleep_summary, user: @user, date: 3.days.ago)
    create(:daily_sleep_summary, user: @user, date: 4.days.ago)
    expect { @user.destroy }.to change { DailySleepSummary.count }.by(-2)
  end

  it "dependent destroy for all_following_relationship" do
    create_list(:follow, 2, follower: @user)
    expect { @user.destroy }.to change { Follow.count }.by(-2)
  end

  it "dependent destroy for all_follower_relationship" do
    create_list(:follow, 2, followed: @user)
    expect { @user.destroy }.to change { Follow.count }.by(-2)
  end

  it "current_sleep_record returns sleeping record" do
    create(:sleep_record, user: @user, sleep_time: 1.hour.ago, awake_time: nil)
    expect(@user.current_sleep_record).not_to be_nil
    expect(@user.current_sleep_record.awake_time).to be_nil
  end

  it "current_sleep_record returns nil if no sleeping record" do
    create(:sleep_record, user: @user, sleep_time: 2.hours.ago, awake_time: 1.hour.ago)
    expect(@user.current_sleep_record).to be_nil
  end

  it "following? returns true if following" do
    create(:follow, follower: @user, followed: @other_user)
    expect(@user.following?(@other_user)).to be_truthy
  end

  it "following? returns false if not following" do
    expect(@user.following?(@other_user)).to be_falsey
  end

  it "following? returns false for non-user object" do
    expect(@user.following?(nil)).to be_falsey
    expect(@user.following?("not a user")).to be_falsey
  end

  it "followable_summaries returns correct counts" do
    create(:follow, follower: @user, followed: @other_user)
    create(:follow, follower: @user, followed: @another_user)
    create(:follow, follower: @another_user, followed: @user)
    create(:follow, follower: @other_user, followed: @user, blocked: true)

    summaries = @user.followable_summaries
    expect(summaries[:following_count]).to eq(2)
    expect(summaries[:followers_count]).to eq(1)
    expect(summaries[:followers_blocked_count]).to eq(1)
  end

  it "ransackable_attributes returns correct attributes" do
    expected_attributes = %i[id name]
    expect(User.ransackable_attributes).to eq(expected_attributes)
  end
end
