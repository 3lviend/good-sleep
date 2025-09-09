module Api
  module V1
    class UsersController < BaseController
      before_action :find_user, only: %i[ show ]

      # GET /api/v1/users
      def index
        @q            = User.ransack(ransack_params)
        @users        = @q.result.page(params[:page]).per(params[:per_page])
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

      def find_user
        @user = Rails.cache.fetch("User::#{params[:id]}", expires_in: 10.minutes) do
          User.find(params[:id])
        end
      end
    end
  end
end
