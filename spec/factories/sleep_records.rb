FactoryBot.define do
  factory :sleep_record do
    association :user

    sleep_time       { Faker::Time.backward(days: 1, period: :night) }
    awake_time       { Faker::Time.forward(days: 1, period: :morning) }
    duration_seconds { awake_time.present? && sleep_time.present? ? (awake_time - sleep_time).to_i : 0 }

    trait :sleeping do
      awake_time { nil }
      duration_seconds { 0 }
    end
  end
end