module Api
  module V1
    class BaseController < ApplicationController
      include Searchable
      include ErrorsHandler

      def pagination_meta(collection: [], cached: false, cache_key: "")
        return build_pagination_meta(collection) unless cached && cache_key.present?

        cached_pagination_meta(collection, cache_key)
      end

      private

      def build_pagination_meta(collection)
        return {} unless collection.respond_to?(:current_page)

        {
          current_page: collection.current_page,
          next_page: collection.next_page,
          prev_page: collection.prev_page,
          page_size: collection.size,
          total_pages: collection.total_pages,
          total_count: collection.total_count
        }
      end

      def cached_pagination_meta(collection, cache_key)
        return {} unless collection.respond_to?(:current_page)

        cache_suffix_key = "#{collection.class}::page-#{collection.current_page}-per-#{collection.limit_value}"
        @pagination_meta = Rails.cache.fetch("#{cache_key}::#{cache_suffix_key}", expires_in: 10.minutes) do
          build_pagination_meta(collection)
        end

        @pagination_meta
      end
    end
  end
end
