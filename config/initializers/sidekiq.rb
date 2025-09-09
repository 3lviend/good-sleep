require "sidekiq"
require "sidekiq/web"

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  if Rails.env.development?
    [ user, password ].eql?(%w[admin admin])
  else
    [ user, password ].eql?(%w[admin admin])
  end
end

Sidekiq.configure_server do |config|
  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file(File.expand_path("../../sidekiq.yml", __FILE__))
    Sidekiq::Scheduler.reload_schedule!
  end
end
