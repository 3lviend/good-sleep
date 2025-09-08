# Create 10 users with random sleep records, for each user, between 1 to 30 past sleep records and optionally a current sleeping record.
user_factory_options = { sleep_record_count: rand(1..30), is_sleeping: true }
FactoryBot.create_list(:user, 10, :with_sleep_records, **user_factory_options)
