# Create 10 users with random sleep records, for each user, between 1 to 30 past sleep records and optionally a current sleeping record.
sleep_record_count   = rand(1..30)
start_date           = (sleep_record_count + 1).days.ago.to_date.to_s
end_date             = Date.yesterday.to_s
user_factory_options = { sleep_record_count: sleep_record_count, is_sleeping: true }

# Create users with associated sleep records
FactoryBot.create_list(:user, 10, :with_sleep_records, **user_factory_options)

# Generate daily sleep summaries for the created sleep records
DailySleepSummaryJob.perform_async(start_date, end_date)
