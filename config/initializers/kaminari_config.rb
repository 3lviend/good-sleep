Kaminari.configure do |config|
  config.default_per_page     = 10
  config.max_per_page         = 100
  config.params_on_first_page = false
  config.param_name           = :page
end
