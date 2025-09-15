module Api
  module V1
    class UsersController < BaseController
      before_action :set_user, only: %i[ show ]

      self.permitted_ransack_params = %i[ id_eq name_cont ]

      # GET /api/v1/users
      def index
        @q            = User.ransack(ransack_params)
        @users        = @q.result.includes(:following, :followers, :blocked, :daily_sleep_summaries).page(params[:page]).per(params[:per_page])
        cache_options = { collection: @users, cached: ransack_params.blank?, cache_key: "Index" }

        render json: {
          users: ActiveModel::Serializer::CollectionSerializer.new(
            @users,
            serializer: UserSerializer
          ),
          pagination: pagination_meta(**cache_options)
        }
      end

      # GET /api/v1/users/:id
      def show
        render json: { user: UserSerializer.new(@user) }, status: 200
      end

      private

      def set_user
        @user = find_user(params[:id]) # Use concern method
      end
    end
  end
end
