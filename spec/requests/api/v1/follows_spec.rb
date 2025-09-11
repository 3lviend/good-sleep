require 'rails_helper'

RSpec.describe "Api::V1::Follows", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "GET /api/v1/users/:user_id/follows" do
    context "when the user is following other users" do
      before do
        create(:follow, follower: user, followed: other_user)
        get "/api/v1/users/#{user.id}/follows"
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "returns the users that the user is following" do
        json_response = JSON.parse(response.body)
        expect(json_response['following'].first['id']).to eq(other_user.id)
      end
    end
  end

  describe "GET /api/v1/users/:user_id/follows/followers" do
    context "when the user has followers" do
      before do
        create_list(:follow, 15, followed: user)
        get "/api/v1/users/#{user.id}/follows/followers", params: { per_page: 10 }
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "returns a paginated list of followers" do
        json_response = JSON.parse(response.body)
        expect(json_response['followers'].size).to eq(10)
        expect(json_response['pagination']['total_pages']).to eq(2)
      end
    end
  end

  describe "GET /api/v1/users/:user_id/follows/blocked" do
    context "when the user has blocked followers" do
      let(:follower) { create(:user) }
      before do
        create(:follow, follower: follower, followed: user, blocked: true)
        get "/api/v1/users/#{user.id}/follows/blocked"
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "returns the blocked users" do
        json_response = JSON.parse(response.body)
        expect(json_response['blocked'].size).to eq(1)
        expect(json_response['blocked'].first['id']).to eq(follower.id)
      end
    end
  end

  describe "POST /api/v1/users/:user_id/follows/request_follow" do
    context "with valid parameters" do
      it "follows the user" do
        expect {
          post "/api/v1/users/#{user.id}/follows/request_follow", params: { followed_user_id: other_user.id }
        }.to change(Follow, :count).by(1)
        expect(response).to have_http_status(:success)
      end
    end

    context "when already following" do
      before do
        create(:follow, follower: user, followed: other_user)
      end

      it "returns an error" do
        post "/api/v1/users/#{user.id}/follows/request_follow", params: { followed_user_id: other_user.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with invalid parameters" do
      it "returns an error when trying to follow self" do
        post "/api/v1/users/#{user.id}/follows/request_follow", params: { followed_user_id: user.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /api/v1/users/:user_id/follows/unfollow" do
    context "when unfollowing a user" do
      before do
        create(:follow, follower: user, followed: other_user)
      end

      it "unfollows the user" do
        expect {
          delete "/api/v1/users/#{user.id}/follows/unfollow", params: { followed_user_id: other_user.id }
        }.to change(Follow, :count).by(-1)
        expect(response).to have_http_status(:success)
      end
    end

    context "when trying to unfollow a user that is not being followed" do
      it "returns an error" do
        delete "/api/v1/users/#{user.id}/follows/unfollow", params: { followed_user_id: other_user.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /api/v1/users/:user_id/follows/block_follower" do
    let(:follower) { create(:user) }
    before do
      create(:follow, follower: follower, followed: user)
    end

    context "when blocking a follower" do
      it "blocks the follower" do
        put "/api/v1/users/#{user.id}/follows/block_follower", params: { follower_user_id: follower.id }
        expect(response).to have_http_status(:success)
        expect(user.blocked.count).to eq(1)
      end
    end
  end

  describe "PUT /api/v1/users/:user_id/follows/unblock_follower" do
    let(:follower) { create(:user) }
    before do
      create(:follow, follower: follower, followed: user, blocked: true)
    end

    context "when unblocking a follower" do
      it "unblocks the follower" do
        put "/api/v1/users/#{user.id}/follows/unblock_follower", params: { follower_user_id: follower.id }
        expect(response).to have_http_status(:success)
        expect(user.blocked.count).to eq(0)
      end
    end
  end
end
