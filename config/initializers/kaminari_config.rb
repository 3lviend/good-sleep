# frozen_string_literal: true

Kaminari.configure do |config|
  config.default_per_page     = 1
  config.max_per_page         = 100
  config.params_on_first_page = false
  config.param_name           = :page
end
