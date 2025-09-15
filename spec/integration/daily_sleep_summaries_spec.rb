require 'rails_helper'
require 'swagger_helper'

describe 'Daily Sleep Summaries API', type: :request do
  path '/api/v1/users/{user_id}/daily_sleep_summaries' do
    get 'Retrieves all daily sleep summaries for a user' do
      tags 'Daily Sleep Summaries'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :string, example: 1
      parameter name: :page, in: :query, type: :integer, required: false, example: 1
      parameter name: :per_page, in: :query, type: :integer, required: false, example: 10
      parameter name: 'q[id_eq]', in: :query, type: :integer, required: false

      response '200', 'daily sleep summaries found' do
        schema type: :object,
          properties: {
            daily_sleep_summaries: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer, example: 1 },
                  date: { type: :string, format: :date, example: "2025-08-13" },
                  total_sleep_duration: { type: :integer, example: 59640 },
                  sleep_duration: {
                    type: :object,
                    properties: {
                      hour: { type: :number, example: 16.57 },
                      minute: { type: :number, example: 994 },
                      second: { type: :integer, example: 59640 }
                    }
                  },
                  sleep_quality_score: { type: :integer, example: 5 },
                  user: {
                    type: :object,
                    properties: {
                      id: { type: :integer, example: 1 },
                      name: { type: :string, example: "Damion Greenfelder" },
                      created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:29.071Z" }
                    }
                  },
                  created_at: { type: :string, format: :'date-time', example: "2025-09-12T17:21:57.408Z" }
                }
              }
            },
            pagination: {
              type: :object,
              properties: {
                current_page: { type: :integer, example: 1 },
                next_page: { type: :integer, nullable: true, example: nil },
                prev_page: { type: :integer, nullable: true, example: nil },
                page_size: { type: :integer, example: 1 },
                total_pages: { type: :integer, example: 1 },
                total_count: { type: :integer, example: 1 }
              }
            }
          }

        let(:user) { create(:user) }
        let(:user_id) { user.id }
        before do
          create_list(:daily_sleep_summary, 1, user: user)
        end
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/daily_sleep_summaries/{id}' do
    get 'Retrieves a daily sleep summary' do
      tags 'Daily Sleep Summaries'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :string, example: 1
      parameter name: :id, in: :path, type: :string

      response '200', 'daily sleep summary found' do
        schema type: :object,
          properties: {
            daily_sleep_summary: {
              type: :object,
              properties: {
                id: { type: :integer, example: 1 },
                date: { type: :string, format: :date, example: "2025-08-13" },
                total_sleep_duration: { type: :integer, example: 59640 },
                sleep_duration: {
                  type: :object,
                  properties: {
                    hour: { type: :number, example: 16.57 },
                    minute: { type: :number, example: 994 },
                    second: { type: :integer, example: 59640 }
                  }
                },
                sleep_quality_score: { type: :integer, example: 5 },
                user: {
                  type: :object,
                  properties: {
                    id: { type: :integer, example: 1 },
                    name: { type: :string, example: "Damion Greenfelder" },
                    created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:29.071Z" }
                  }
                },
                created_at: { type: :string, format: :'date-time', example: "2025-09-12T17:21:57.408Z" }
              }
            }
          }

        let(:user) { create(:user) }
        let(:user_id) { user.id }
        let(:id) { create(:daily_sleep_summary, user: user).id }
        run_test!
      end

      response '404', 'daily sleep summary not found' do
        schema type: :object,
          properties: {
            message: { type: :string, example: 'Record not found' }
          }
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
