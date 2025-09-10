module Api
  module V1
    class DailySleepSummariesController < BaseController
      before_action :find_user

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

      def find_user
        @user = Rails.cache.fetch("User::#{params[:user_id]}", expires_in: 10.minutes) do
          User.find(params[:user_id])
        end
      end
    end
  end
end
