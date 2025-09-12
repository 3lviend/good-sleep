require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  before do
    @user = create(:user)
  end

  it "should belong to a user" do
    sleep_record = build(:sleep_record)
    expect(sleep_record).to be_valid

    sleep_record = build(:sleep_record, user: nil)
    expect(sleep_record).not_to be_valid
  end

  it "should not be valid without sleep_time" do
    sleep_record = build(:sleep_record, sleep_time: nil, user: @user)
    expect(sleep_record).not_to be_valid
    expect(sleep_record.errors[:sleep_time]).to include("can't be blank")
  end

  it "awake_time should be greater than sleep_time or blank" do
    sleep_record = build(:sleep_record, sleep_time: Time.current, awake_time: Time.current - 1.hour, user: @user)
    expect(sleep_record).not_to be_valid
    expect(sleep_record.errors[:awake_time].first).to match(/must be greater than/)

    sleep_record = build(:sleep_record, sleep_time: Time.current, awake_time: nil)
    expect(sleep_record).to be_valid
  end

  it "duration_seconds should be a non-negative integer when not sleeping" do
    sleep_record = build(:sleep_record, user: @user, duration_seconds: -1)
    expect(sleep_record).not_to be_valid
    expect(sleep_record.errors[:duration_seconds]).to include("must be greater than or equal to 0")

    # can be 0 if sleeping
    sleep_record = build(:sleep_record, user: @user, duration_seconds: 0, awake_time: nil)
    expect(sleep_record).to be_valid

    sleep_record = build(:sleep_record, user: @user, duration_seconds: 10.5)
    expect(sleep_record).not_to be_valid
    expect(sleep_record.errors[:duration_seconds]).to include("must be an integer")
  end

  it "set_sleep_duration callback on update" do
    sleep_record = create(:sleep_record, :sleeping, user: @user, sleep_time: 8.hours.ago)
    expect(sleep_record.duration_seconds).to eq(0)

    travel_to 1.hour.from_now do
      awake_time = Time.current
      expected_duration = (awake_time - sleep_record.sleep_time).to_i
      sleep_record.update(awake_time: awake_time)
      expect(sleep_record.duration_seconds).to be_within(1).of(expected_duration)
    end
  end

  it "sleep_duration returns duration in seconds by default" do
    sleep_record = create(:sleep_record, user: @user, sleep_time: 8.hours.ago, awake_time: 1.hour.ago)
    expect(sleep_record.sleep_duration).to eq(7.hours.to_i)
  end

  it "sleep_duration returns duration in hours" do
    sleep_record = create(:sleep_record, user: @user, sleep_time: 8.hours.ago, awake_time: 1.hour.ago)
    expect(sleep_record.sleep_duration(:hour)).to eq(7.0)
  end

  it "sleep_duration returns duration in minutes" do
    sleep_record = create(:sleep_record, user: @user, sleep_time: 8.hours.ago, awake_time: 1.hour.ago)
    expect(sleep_record.sleep_duration(:minute)).to eq(420.0)
  end

  it "sleep_duration returns nil if sleeping" do
    sleep_record = create(:sleep_record, :sleeping, user: @user)
    expect(sleep_record.sleep_duration).to be_nil
  end

  it "wakeup! sets awake_time and duration_seconds" do
    sleep_record = create(:sleep_record, :sleeping, user: @user, sleep_time: 8.hours.ago)
    expect(sleep_record.awake_time).to be_nil
    expect(sleep_record.duration_seconds).to eq(0)

    travel_to 1.hour.from_now do
      expected_awake_time = Time.current
      expected_duration = (expected_awake_time - sleep_record.sleep_time).to_i
      sleep_record.wakeup!
      expect(sleep_record.awake_time).not_to be_nil
      expect(sleep_record.duration_seconds).to be_within(1).of(expected_duration)
    end
  end

  it "ransackable_attributes" do
    expected_attributes = %w[id sleep_time awake_time duration_seconds]
    expect(SleepRecord.ransackable_attributes).to eq(expected_attributes)

    tomorrow = 1.day.from_now.beginning_of_day
    sleep1, sleep2, sleep3 = [nil, nil, nil]

    travel_to tomorrow do
      sleep1 = create(:sleep_record, :sleeping, sleep_time: 4.hours.ago)
      sleep2 = create(:sleep_record, :sleeping, sleep_time: 6.hours.ago)
      sleep3 = create(:sleep_record, :sleeping, sleep_time: 3.hours.ago)
    end

    expect(SleepRecord.ransack({sleep_time_gteq: tomorrow - 5.hours}).result.count).to eq(2)
    expect(SleepRecord.ransack({sleep_time_lteq: tomorrow - 5.hours}).result.count).to eq(1)

    travel_to (tomorrow + 4.hours) do
      sleep1.wakeup!
    end
    travel_to (tomorrow + 1.hours) do
      sleep2.wakeup!
    end
    travel_to (tomorrow + 6.hours) do
      sleep3.wakeup!
    end

    expect(SleepRecord.ransack({awake_time_gteq: tomorrow + 2.hours}).result.count).to eq(2)
    expect(SleepRecord.ransack({awake_time_lteq: tomorrow + 2.hours}).result.count).to eq(1)

    expect(SleepRecord.ransack({duration_seconds_gteq: 8.hours.to_i}).result.count).to eq(2)
    expect(SleepRecord.ransack({duration_seconds_lteq: 7.hours.to_i}).result.count).to eq(1)
  end

  it "ransackable_scopes" do
    expected_scopes = %w[sleep_time_between awake_time_between duration_seconds_between]
    expect(SleepRecord.ransackable_scopes).to eq(expected_scopes)

    tomorrow = 1.day.from_now.beginning_of_day
    sleep1, sleep2, sleep3 = [nil, nil, nil]

    travel_to tomorrow do
      sleep1 = create(:sleep_record, :sleeping, sleep_time: 4.hours.ago)
      sleep2 = create(:sleep_record, :sleeping, sleep_time: 6.hours.ago)
      sleep3 = create(:sleep_record, :sleeping, sleep_time: 3.hours.ago)
    end

    travel_to (tomorrow + 4.hours) do
      sleep1.wakeup!
    end
    travel_to (tomorrow + 1.hours) do
      sleep2.wakeup!
    end
    travel_to (tomorrow + 6.hours) do
      sleep3.wakeup!
    end

    expect(SleepRecord.ransack({sleep_time_between: [tomorrow - 3.hours, tomorrow - 2.hours]}).result.count).to eq(1)
    expect(SleepRecord.ransack({awake_time_between: [tomorrow + 1.hours, tomorrow + 2.hours]}).result.count).to eq(1)
    expect(SleepRecord.ransack({duration_seconds_between: [8.hours, 9.hours]}).result.count).to eq(2)
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
