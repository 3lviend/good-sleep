require 'swagger_helper'

describe 'Users API', type: :request do
  path '/api/v1/users' do
    get 'Retrieves all users' do
      tags 'Users'
      produces 'application/json'

      response '200', 'List of users - Success' do
        schema type: :object,
          properties: {
            users: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string, example: 'John Doe' },
                  followable_summaries: {
                    type: :object,
                    properties: {
                      following_count: { type: :integer, example: 5 },
                      followers_count: { type: :integer, example: 10 },
                      followers_blocked_count: { type: :integer, example: 0 }
                    }
                  },
                  last_30_days_sleep_summaries: {
                    type: :object,
                    properties: {
                      total_sleep_duration: {
                        type: :object,
                        properties: {
                          hour: { type: :number, example: 10.17 },
                          minute: { type: :integer, example: 610 },
                          second: { type: :integer, example: 36600 }
                        }
                      },
                      average_sleep_duration: {
                        type: :object,
                        properties: {
                          hour: { type: :number, example: 10.17, nullable: true },
                          minute: { type: :integer, example: 610, nullable: true },
                          second: { type: :integer, example: 36600, nullable: true }
                        }
                      },
                      average_sleep_quality_score: { type: :number, example: 8 }
                    }
                  },
                  created_at: { type: :string, format: :'date-time' }
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
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    get 'Retrieves a user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'User found - Success' do
        let(:user) { create(:user) }
        let(:id) { user.id }
        schema type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string, example: 'John Doe' },
                followable_summaries: {
                  type: :object,
                  properties: {
                    following_count: { type: :integer, example: 5 },
                    followers_count: { type: :integer, example: 10 },
                    followers_blocked_count: { type: :integer, example: 0 }
                  }
                },
                last_30_days_sleep_summaries: {
                  type: :object,
                  properties: {
                    total_sleep_duration: {
                      type: :object,
                      properties: {
                        hour: { type: :number, example: 10.17 },
                        minute: { type: :integer, example: 610 },
                        second: { type: :integer, example: 36600 }
                      }
                    },
                    average_sleep_duration: {
                      type: :object,
                      properties: {
                        hour: { type: :number, nullable: true, example: 10.17 },
                        minute: { type: :integer, nullable: true, example: 610 },
                        second: { type: :integer, nullable: true, example: 36600 }
                      }
                    },
                    average_sleep_quality_score: { type: :number, example: 8 }
                  }
                },
                created_at: { type: :string, format: :'date-time' }
              }
            }
          }
        run_test!
      end

      response '404', 'User not found' do
        let(:id) { 0 }
        schema type: :object,
          properties: {
            message: { type: :string, example: 'Record not found' }
          }
        run_test!
      end
    end
  end
end
