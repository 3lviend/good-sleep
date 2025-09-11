require 'rails_helper'

RSpec.describe DailySleepSummary, type: :model do
  before do
    @user = create(:user)
    @summary = create(:daily_sleep_summary, user: @user, total_sleep_duration: 25200, date: 6.days.ago) # 7 hours
  end

  it "should belong to a user" do
    expect(@summary.user).to eq(@user)
  end

  it "should not be valid without a date" do
    @summary.date = nil
    expect(@summary).not_to be_valid
    expect(@summary.errors[:date]).to include("can't be blank")
  end

  it "should not be valid without total_sleep_duration" do
    @summary.total_sleep_duration = nil
    expect(@summary).not_to be_valid
    expect(@summary.errors[:total_sleep_duration]).to include("is not a number")
  end

  it "total_sleep_duration should be greater than or equal to 0" do
    @summary.total_sleep_duration = -1
    expect(@summary).not_to be_valid
    expect(@summary.errors[:total_sleep_duration]).to include("must be greater than or equal to 0")
  end

  it "sleep_quality_score is set before save based on total_sleep_duration" do
    # 7 hours (25200 seconds) -> score 10
    summary_7_hours = create(:daily_sleep_summary, user: @user, total_sleep_duration: 25200, date: 1.day.ago)
    expect(summary_7_hours.sleep_quality_score).to eq(10)

    # 5 hours (18000 seconds) -> score 8
    summary_5_hours = create(:daily_sleep_summary, user: @user, total_sleep_duration: 18000, date: 2.days.ago)
    expect(summary_5_hours.sleep_quality_score).to eq(8)

    # 10 hours (36000 seconds) -> score 8
    summary_10_hours = create(:daily_sleep_summary, user: @user, total_sleep_duration: 36000, date: 3.days.ago)
    expect(summary_10_hours.sleep_quality_score).to eq(8)

    # 3 hours (10800 seconds) -> score 5
    summary_3_hours = create(:daily_sleep_summary, user: @user, total_sleep_duration: 10800, date: 4.days.ago)
    expect(summary_3_hours.sleep_quality_score).to eq(5)

    # 13 hours (46800 seconds) -> score 5
    summary_13_hours = create(:daily_sleep_summary, user: @user, total_sleep_duration: 46800, date: 5.days.ago)
    expect(summary_13_hours.sleep_quality_score).to eq(5)
  end

  it "sleep_duration returns seconds by default" do
    expect(@summary.sleep_duration).to eq(25200)
  end

  it "sleep_duration returns hours" do
    expect(@summary.sleep_duration(:hour)).to eq(7.0)
  end

  it "sleep_duration returns minutes" do
    expect(@summary.sleep_duration(:minute)).to eq(420.0)
  end

  it "last_month scope returns summaries from the last month" do
    # Create summaries within the last month
    create(:daily_sleep_summary, user: @user, date: 15.days.ago, total_sleep_duration: 20000)
    create(:daily_sleep_summary, user: @user, date: 5.days.ago, total_sleep_duration: 20000)

    # Create a summary older than a month
    create(:daily_sleep_summary, user: @user, date: 35.days.ago, total_sleep_duration: 20000)

    # The @summary created in setup is also within the last month (7 hours ago)
    expect(DailySleepSummary.last_month.count).to eq(3)
  end
end
