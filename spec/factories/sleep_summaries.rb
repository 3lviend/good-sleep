FactoryBot.define do
  factory :daily_sleep_summary do
    association :user
    date { Faker::Date.backward(days: 1) }
    total_sleep_duration { Faker::Number.between(from: 14400, to: 36000) } # 4 to 10 hours in seconds
  end
end