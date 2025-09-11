class UserSerializer < ActiveModel::Serializer
  attributes :id, :name
  attribute :followable_summaries, if: :include_followable_summaries?

  def include_followable_summaries?
    instance_options[:include_followable_summaries] || true
  end

  def followable_summaries
    object.followable_summaries
  end
  attributes :last_30_days_sleep_summaries
  attributes :created_at

  def last_30_days_sleep_summaries
    object.fetch_cache("#{object.default_cache_key}::SleepSummaries") do
      sleep_duration = retrieve_sleep_durations
      total_sleep_duration = calculate_total_sleep_durations(sleep_duration)
      average_sleep_duration = calculate_average_sleep_durations(sleep_duration)

      {
        total_sleep_duration: total_sleep_duration,
        average_sleep_duration: average_sleep_duration,
        average_sleep_quality_score: object.daily_sleep_summaries.average(:sleep_quality_score).to_f.round(2)
      }
    end
  end

  private

  def retrieve_sleep_durations
    sleep_summaries = object.daily_sleep_summaries.last_month

    {
      hour: sleep_summaries.map { |sleep_summary| { date: sleep_summary.date, duration: sleep_summary.sleep_duration(:hour) } },
      minute: sleep_summaries.map { |sleep_summary| { date: sleep_summary.date, duration: sleep_summary.sleep_duration(:minute) } },
      second: sleep_summaries.map { |sleep_summary| { date: sleep_summary.date, duration: sleep_summary.sleep_duration(:second) } }
    }
  end

  def calculate_total_sleep_durations(sleep_duration_data = {})
    sleep_duration_data.map do |key, values|
      total_duration = values.pluck(:duration).sum
      [ key, total_duration.round(2) ]
    end.to_h
  end

  def calculate_average_sleep_durations(sleep_duration_data = {})
    sleep_duration_data.map do |key, values|
      durations = values.pluck(:duration)
      [ key, (durations.sum / durations.size.to_f).round(2) ]
    end.to_h
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
