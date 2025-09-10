require "sidekiq"
require "sidekiq/web"
require "sidekiq-scheduler"

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  if Rails.env.development?
    [ user, password ].eql?(%w[admin admin])
  else
    [ user, password ].eql?(%w[admin admin])
  end
end

Sidekiq.configure_server do |config|
  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file(File.expand_path("#{Rails.root}/config/schedule.yml", __FILE__))
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end
end
