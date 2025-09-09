class DailySleepSummaryJob
  include Sidekiq::Job

  def perform(start_date_str = nil, end_date_str = nil)
    start_date = start_date_str ? DateTime.parse(start_date_str) : Date.yesterday.to_datetime
    end_date = end_date_str ? DateTime.parse(end_date_str) : start_date

    (start_date..end_date).each do |date|
      User.find_each do |user|
        sleep_records = user.sleep_records.where(sleep_time: date.to_time.all_day)

        next if sleep_records.empty?

        total_duration = sleep_records.sum(&:duration_seconds)
        # This is a placeholder for sleep quality score calculation, to be updated later.
        sleep_quality_score = rand(50..100)

        DailySleepSummary.find_or_create_by!(user: user, date: date) do |summary|
          summary.total_sleep_duration = total_duration
          summary.sleep_quality_score = sleep_quality_score
        end
      end
    end
  end
end
