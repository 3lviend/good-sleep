require 'rails_helper'

RSpec.describe "Api::V1::SleepRecords", type: :request do
  let(:user) { create(:user) }

  describe "GET /api/v1/users/:user_id/sleep_records" do
    context "with pagination" do
      before do
        create_list(:sleep_record, 15, user: user)
        get "/api/v1/users/#{user.id}/sleep_records", params: { per_page: 10 }
      end

      it "returns a paginated list of sleep records" do
        json_response = JSON.parse(response.body)
        expect(json_response['sleep_records'].size).to eq(10)
        expect(json_response['pagination']['total_pages']).to eq(2)
      end
    end

    context "with filtering" do
      before do
        # This record should not be returned (duration is 3600 seconds)
        create(:sleep_record, user: user, sleep_time: Time.current - 1.hour, awake_time: Time.current)
        # This record should be returned (duration is 7200 seconds)
        create(:sleep_record, user: user, sleep_time: Time.current - 2.hours, awake_time: Time.current)
        get "/api/v1/users/#{user.id}/sleep_records", params: { q: { duration_seconds_gteq: 7000 } }
      end

      it "returns filtered sleep records" do
        json_response = JSON.parse(response.body)
        expect(json_response['sleep_records'].size).to eq(1)
        expect(json_response['sleep_records'].first['sleep_duration']['second']).to be >= 7000
      end
    end
  end

  describe "GET /api/v1/users/:user_id/sleep_records/:id" do
    let(:sleep_record) { create(:sleep_record, user: user) }

    context "when the record exists" do
      before do
        get "/api/v1/users/#{user.id}/sleep_records/#{sleep_record.id}"
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "returns the sleep record" do
        json_response = JSON.parse(response.body)
        expect(json_response['sleep_record']['id']).to eq(sleep_record.id)
      end
    end

    context "when the record does not exist" do
      it "returns a not found error" do
        get "/api/v1/users/#{user.id}/sleep_records/9999"
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /api/v1/users/:user_id/sleep_records/clock_in" do
    context "when not already sleeping" do
      it "creates a new sleep record" do
        expect {
          post "/api/v1/users/#{user.id}/sleep_records/clock_in"
        }.to change(SleepRecord, :count).by(1)
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['sleep_record']['awake_time']).to be_nil
      end
    end

    context "when already sleeping" do
      before do
        create(:sleep_record, user: user, awake_time: nil)
      end

      it "does not create a new sleep record" do
        expect {
          post "/api/v1/users/#{user.id}/sleep_records/clock_in"
        }.not_to change(SleepRecord, :count)
      end
    end
  end

  describe "PUT /api/v1/users/:user_id/sleep_records/clock_out" do
    context "when there is an active sleep record" do
      before do
        create(:sleep_record, user: user, awake_time: nil)
      end

      it "updates the sleep record" do
        put "/api/v1/users/#{user.id}/sleep_records/clock_out"
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['sleep_record']['awake_time']).not_to be_nil
      end
    end

    context "when there is no active sleep record" do
      it "returns an error" do
        put "/api/v1/users/#{user.id}/sleep_records/clock_out"
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
