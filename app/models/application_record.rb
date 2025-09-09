class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def default_cache_key
    "#{self.class.name}::#{id}"
  end

  def fetch_cache(cache_key = default_cache_key, expires_in: 1.day)
    Rails.cache.fetch(cache_key) do
      yield
    end
  end

  def clear_cache(cache_key = default_cache_key)
    Rails.cache.delete(cache_key)
    Rails.cache.delete_matched("#{cache_key}::*")
    Rails.cache.delete_matched("Index::#{cache_key.split("::").first}::*")
  end
end
