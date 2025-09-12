# frozen_string_literal: true

if defined?(Bullet)
  Bullet.enable = true
  Bullet.bullet_logger = true # Log warnings to the Bullet log file (log/bullet.log)
  Bullet.rails_logger = true # Log warnings to the Rails log file (log/development.log or log/test.log)
end
