module Api
  module V1
    class FollowsController < BaseController
      before_action :find_user

      # GET /api/v1/users/:user_id/follows
      def index
        @followed_users = @user.following.page(params[:page]).per(params[:per_page])
        cache_options = { collection: @followed_users, cached: true, cache_key: @user.default_cache_key }

        render json: {
          following: ActiveModel::Serializer::CollectionSerializer.new(
            @followed_users,
            serializer: FollowSerializer
          ),
          pagination: pagination_meta(**cache_options)
        }
      end

      # GET /api/v1/users/:user_id/follows/followers
      def followers
        @followed_users = @user.followers.page(params[:page]).per(params[:per_page])
        cache_options = { collection: @followed_users, cached: true, cache_key: @user.default_cache_key }

        render json: {
          followers: ActiveModel::Serializer::CollectionSerializer.new(
            @followed_users,
            serializer: FollowSerializer
          ),
          pagination: pagination_meta(**cache_options)
        }
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
