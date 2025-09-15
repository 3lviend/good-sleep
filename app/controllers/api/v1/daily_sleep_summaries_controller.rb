# Note:
# - This controller manages daily sleep summaries for users.
# - It includes actions to list all daily sleep summaries for a user and to show a specific daily sleep summary.
# - It uses caching to optimize performance and reduce database load.
# - Pagination using the `kaminari` gem is implemented for listing endpoints, that configured on 'config/initializers/kaminari_config.rb'.
# - Maximum per page is set to 100, default is 10.

module Api
  module V1
    class DailySleepSummariesController < BaseController
      before_action :set_user

      # GET /api/v1/users/:user_id/daily_sleep_summaries
      def index
        @q                     = @user.daily_sleep_summaries.ransack(ransack_params)
        @daily_sleep_summaries = @q.result.page(params[:page]).per(params[:per_page])
        cache_options = { collection: @daily_sleep_summaries, cached: ransack_params.blank?, cache_key: "Index" }

        render json: {
          daily_sleep_summaries: ActiveModel::Serializer::CollectionSerializer.new(
            @daily_sleep_summaries,
            serializer: DailySleepSummarySerializer
          ),
          pagination: pagination_meta(**cache_options)
        }
      end

      # GET /api/v1/users/:user_id/daily_sleep_summaries/:id
      def show
        @daily_sleep_summary = @user.fetch_cache("#{@user.default_cache_key}::DailySleepSummary::#{params[:id]}") do
          @user.daily_sleep_summaries.find(params[:id])
        end
        render json: { daily_sleep_summary: DailySleepSummarySerializer.new(@daily_sleep_summary) }, status: 200
      end

      private

      def set_user
        @user = find_user # Use concern method
      end
    end
  end
end
