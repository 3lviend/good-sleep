# Note:
# - This controller manages user follow relationships, including following, unfollowing, blocking, and unblocking users.
# - It provides endpoints to list followed users, followers, and blocked users.
# - It provides action endpoints to follow, unfollow, block, and unblock users.
# - It uses caching to optimize performance and reduce database load.
# - Pagination using the `kaminari` gem is implemented for listing endpoints, that configured on 'config/initializers/kaminari_config.rb'.
# - Maximum per page is set to 100, default is 10.

module Api
  module V1
    class FollowsController < BaseController
      before_action :set_user

      # GET /api/v1/users/:user_id/follows
      def index
        @followed_users = @user.following.includes(:sleep_records).page(params[:page]).per(params[:per_page])
        cache_options = {
          collection: @followed_users, cached: true,
          cache_key: "#{@user.default_cache_key}::Following"
        }

        render json: {
          following: ActiveModel::Serializer::CollectionSerializer.new(
            @followed_users,
            serializer: UserFollowSerializer
          ),
          pagination: pagination_meta(**cache_options)
        }
      end

      # GET /api/v1/users/:user_id/follows/followers
      def followers
        @followed_users = @user.followers.includes(:sleep_records).page(params[:page]).per(params[:per_page])
        cache_options = {
          collection: @followed_users, cached: true,
          cache_key: "#{@user.default_cache_key}::Followers"
        }

        render json: {
          followers: ActiveModel::Serializer::CollectionSerializer.new(
            @followed_users,
            serializer: UserFollowSerializer
          ),
          pagination: pagination_meta(**cache_options)
        }
      end

      # GET /api/v1/users/:user_id/follows/blocked
      def blocked
        @blocked_users = @user.blocked.page(params[:page]).per(params[:per_page])
        cache_options = {
          collection: @blocked_users, cached: true,
          cache_key: "#{@user.default_cache_key}::Blocked"
        }

        render json: {
          blocked: ActiveModel::Serializer::CollectionSerializer.new(
            @blocked_users,
            serializer: UserSerializer
          ),
          pagination: pagination_meta(**cache_options)
        }
      end

      # POST /api/v1/users/:user_id/follows/request_follow
      def request_follow
        followed_user_id = params[:followed_user_id]
        @follow          = @user.following_relationship.build(followed_id: followed_user_id)
        if @follow.save
          @other_user = @follow.followed
          clear_users_caches([ @user, @other_user ], %w[Following Follower])
          render json: {
            user: UserSerializer.new(@other_user),
            message: "Successfully followed #{@other_user.name}."
          }, status: 200
        else
          render json: { error: @follow.errors.full_messages.to_sentence }, status: 422
        end
      end

      # DELETE /api/v1/users/:user_id/follows/unfollow
      def unfollow
        followed_user_id = params[:followed_user_id]
        @follow_data     = retrieve_following_data(followed_user_id)
        @other_user      = @follow_data[:user]
        @follow          = @follow_data[:follow]
        if @follow.blank? && !@other_user.following?(@user)
          render json: { error: "You are not following #{@follow_data[:user].name} or got blocked." }, status: 422 and return
        end

        if @follow.destroy
          clear_users_caches([ @user, @other_user ], %w[Following Follower])
          render json: {
            user: UserSerializer.new(@other_user),
            message: "Successfully unfollowed #{@other_user.name}."
          }, status: 200
        else
          render json: { error: @follow.errors.full_messages.to_sentence }, status: 422
        end
      end

      # PUT|PATCH /api/v1/users/:user_id/follows/block_follower
      def block_follower
        follower_user_id = params[:follower_user_id]
        @follow_data     = retrieve_follower_data(follower_user_id)
        @other_user      = @follow_data[:user]
        @follow          = @follow_data[:follow]
        if @follow.blank? && !@other_user.following?(@user)
          render json: { error: "You are followed by user #{@follow_data[:user].name}." }, status: 422 and return
        end

        if @follow.block!
          clear_users_caches([ @user, @other_user ], %w[Following Follower Blocked])
          render json: {
            user: UserSerializer.new(@other_user),
            message: "Successfully blocked #{@other_user.name}."
          }, status: 200
        else
          render json: { error: @follow.errors.full_messages.to_sentence }, status: 422
        end
      end

      # PUT|PATCH /api/v1/users/:user_id/follows/unblock_follower
      def unblock_follower
        follower_user_id = params[:follower_user_id]
        @follow_data     = retrieve_follower_data(follower_user_id)
        @other_user      = @follow_data[:user]
        @follow          = @follow_data[:follow]
        if @follow.blank? && !@other_user.following?(@user)
          render json: { error: "You are followed by user #{@follow_data[:user].name}." }, status: 422 and return
        end

        if @follow.unblock!
          clear_users_caches([ @user, @other_user ], %w[Following Follower Blocked])

          render json: {
            user: UserSerializer.new(@other_user),
            message: "Successfully unblocked #{@other_user.name}."
          }, status: 200
        else
          render json: { error: @follow.errors.full_messages.to_sentence }, status: 422
        end
      end

      private

      def set_user
        @user = find_user # Use concern method
      end

      def retrieve_following_data(user_id)
        other_user = find_user(user_id) # Use concern method
        { user: other_user, follow: @user.following_relationship.find_by(followed_id: user_id) }
      end

      def retrieve_follower_data(user_id)
        other_user = find_user(user_id) # Use concern method
        { user: other_user, follow: @user.all_follower_relationship.find_by(follower_id: user_id) }
      end

      def clear_users_caches(users, cache_keys)
        return if users.blank? || cache_keys.blank?

        users.each do |user|
          cache_keys.each { |key| user.clear_cache("#{user.default_cache_key}::#{key}") }
        end
      end
    end
  end
end
