QueryTrack::Settings.configure do |config|
  if Rails.env.development?
    config.duration = 0.005
  elsif Rails.env.production?
    config.duration = 0.1
  else
    config.duration = 0.05
  end

  config.logs = true
end