module DurationConverter
  extend ActiveSupport::Concern

  def convert_duration(duration_in_seconds, duration_type = :second)
    return 0 if duration_in_seconds.blank?

    case duration_type
    when :hour
      # Convert seconds to hours and round to 2 decimal places
      (duration_in_seconds / 3600.0).round(2)
    when :minute
      # Convert seconds to minutes and round to 2 decimal places
      (duration_in_seconds / 60.0).round(2)
    else
      duration_in_seconds
    end
  end
end
