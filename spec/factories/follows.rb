FactoryBot.define do
  factory :follow do
    association :follower, factory: :user
    association :followed, factory: :user

    trait :blocked do
      blocked { true }
    end
  end
end