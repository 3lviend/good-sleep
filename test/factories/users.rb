FactoryBot.define do
  DEFAULT_SLEEP_COUNT = 365

  factory :user do
    name { Faker::Name.name }

    trait :with_sleep_records do
      transient do
        sleep_record_count { DEFAULT_SLEEP_COUNT }
        is_sleeping        { false }
      end

      # Create associated sleep records after creating the user
      after(:create) do |user, evaluator|
        # Create past sleep records
        evaluator.sleep_record_count.times do |idx|
          sleep_day      = Time.current - (DEFAULT_SLEEP_COUNT - idx).days
          sleep_time     = sleep_day.change(hour: rand(18..23), min: rand(0..59))
          awake_time     = sleep_day.change(hour: rand(9..11), min: rand(0..59)) + 1.days
          sleep_duration = (awake_time - sleep_time).to_i

          create(:sleep_record, {
            user: user, sleep_time: sleep_time, awake_time: awake_time, duration_seconds: sleep_duration
          })
        end

        # Optionally create a current sleeping record
        if evaluator.is_sleeping
          sleep_time = Date.yesterday.to_datetime.change(hour: rand(18..23), min: rand(0..59))
          create(:sleep_record, :sleeping, {
            user: user, sleep_time: sleep_time
          })
        end
      end
    end
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
