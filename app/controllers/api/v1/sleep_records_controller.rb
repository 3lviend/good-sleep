# Note:
# - This controller manages user sleep records, including clocking in and out of sleep sessions.
# - It provides endpoints to list and show sleep records, as well as to clock in and clock out.
# - It uses caching to optimize performance and reduce database load.
# - Pagination using the `kaminari` gem is implemented for listing endpoints, that configured on 'config/initializers/kaminari_config.rb'.
# - Maximum per page is set to 100, default is 10.

module Api
  module V1
    class SleepRecordsController < BaseController
      before_action :find_user

      self.permitted_ransack_params = [
        :id_eq,
        :sleep_time_gteq, :sleep_time_lteq,
        :awake_time_gteq, :awake_time_lteq,
        :duration_seconds_gteq, :duration_seconds_lteq,
        sleep_time_between: [], awake_time_between: [], duration_seconds_between: []
      ]

      # GET  /api/v1/users/:user_id/sleep_records
      def index
        @q             = @user.sleep_records.ransack(ransack_params)
        @sleep_records = @q.result.order_by_newest.page(params[:page]).per(params[:per_page])
        cache_options  = {
          collection: @sleep_records,
          cached: ransack_params.blank?,
          cache_key: @user.default_cache_key
        }

        render json: {
          sleep_records: ActiveModel::Serializer::CollectionSerializer.new(
            @sleep_records,
            serializer: SleepRecordSerializer
          ),
          pagination: pagination_meta(**cache_options)
        }
      end

      # GET  /api/v1/users/:user_id/sleep_records/following
      def following
        @following_users_ids = @user.following.ids
        @q                   = SleepRecord.includes(:user).where(user_id: @following_users_ids).ransack(ransack_params)
        @sleep_records       = @q.result.longest.page(params[:page]).per(params[:per_page])
        cache_options        = {
          collection: @sleep_records,
          cached: false
        }

        render json: {
          sleep_records: ActiveModel::Serializer::CollectionSerializer.new(
            @sleep_records,
            serializer: SleepRecordSerializer
          ),
          pagination: pagination_meta(**cache_options)
        }
      end

      # GET  /api/v1/users/:user_id/sleep_records/:id
      def show
        @sleep_record = @user.fetch_cache("#{@user.default_cache_key}::SleepRecord::#{params[:id]}") do
          @user.sleep_records.find(params[:id])
        end
        render json: { sleep_record: SleepRecordSerializer.new(@sleep_record) }, status: 200
      end

      # POST /api/v1/users/:user_id/clock_in
      def clock_in
        @sleep_record = @user.current_sleep_record || @user.sleep_records.build
        @sleep_record.sleep_time = Time.current
        @sleep_record.save
        @user.clear_cache

        render json: { sleep_record: SleepRecordSerializer.new(@sleep_record) }, status: 200
      end

      # PUT|PATCH /api/v1/users/:user_id/clock_out
      def clock_out
        @sleep_record = @user.current_sleep_record
        unless @sleep_record
          render json: { error: "No active sleep record found. Please clock in first." }, status: 400 and return
        end

        @sleep_record.awake_time = Time.current
        @sleep_record.save
        @user.clear_cache

        render json: { sleep_record: SleepRecordSerializer.new(@sleep_record) }, status: 200
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
