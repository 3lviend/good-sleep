# This file is used to configure rack-attack.

unless Rails.env.test?
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" })

  # Throttle all requests by IP address
  Rack::Attack.throttle("req/ip", limit: 5, period: 5.seconds) do |req|
    req.ip
  end

  # Throttle POST requests to /api/v1/users by IP address
  Rack::Attack.throttle("logins/ip", limit: 5, period: 20.seconds) do |req|
    if req.path == "/api/v1/users" && req.post?
      req.ip
    end
  end
end
