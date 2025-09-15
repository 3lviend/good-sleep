# This file is used to configure Sidekiq.

Sidekiq.configure_server do |config|
  # This is the Redis database used for Sidekiq.
  # It is recommended to use a separate Redis instance for Sidekiq in production.
  config.redis = { url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/0" } }
end

Sidekiq.configure_client do |config|
  # This is the Redis database used for Sidekiq.
  # It is recommended to use a separate Redis instance for Sidekiq in production.
  config.redis = { url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/0" } }
end
