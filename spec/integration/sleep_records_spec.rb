require 'rails_helper'
require 'swagger_helper'

describe 'Sleep Records API', type: :request do
  path '/api/v1/users/{user_id}/sleep_records' do
    get 'Retrieves all sleep records for a user' do
      tags 'Sleep Records'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :string, example: 1
      parameter name: :page, in: :query, type: :integer, required: false, example: 1
      parameter name: :per_page, in: :query, type: :integer, required: false, example: 10
      parameter name: 'q[id_eq]', in: :query, type: :integer, required: false
      parameter name: 'q[sleep_time_gteq]', in: :query, type: :string, format: 'date-time', required: false, description: "Filter by sleep time greater than or equal to a given datetime. (e.g., '2025-09-09 23:52:01')"
      parameter name: 'q[sleep_time_lteq]', in: :query, type: :string, format: 'date-time', required: false, description: "Filter by sleep time less than or equal to a given datetime. (e.g., '2025-09-10 09:21:00')"
      parameter name: 'q[sleep_time_between][]', in: :query, type: :string, format: 'date-time', required: false, description: "Filter by sleep time between given datetime begin. (e.g., '2025-09-10 09:21:00')"
      parameter name: 'q[sleep_time_between][]', in: :query, type: :string, format: 'date-time', required: false, description: "Filter by sleep time between given datetime end. (e.g., '2025-09-10 09:23:00')"
      parameter name: 'q[awake_time_gteq]', in: :query, type: :string, format: 'date-time', required: false, description: "Filter by awake time greater than or equal to a given datetime. (e.g., '2025-09-09 23:52:01')"
      parameter name: 'q[awake_time_lteq]', in: :query, type: :string, format: 'date-time', required: false, description: "Filter by awake time less than or equal to a given datetime. (e.g., '2025-09-10 09:21:00')"
      parameter name: 'q[awake_time_between][]', in: :query, type: :string, format: 'date-time', required: false, description: "Filter by awake time betweeen given datetime begin. (e.g., '2025-09-10 09:21:00')"
      parameter name: 'q[awake_time_between][]', in: :query, type: :string, format: 'date-time', required: false, description: "Filter by awake time betweeen given datetime end. (e.g., '2025-09-10 10:00:00')"
      parameter name: 'q[duration_seconds_gteq]', in: :query, type: :integer, required: false, description: 'Filter by duration in seconds greater than or equal to a given value.'
      parameter name: 'q[duration_seconds_lteq]', in: :query, type: :integer, required: false, description: 'Filter by duration in seconds less than or equal to a given value.'
      parameter name: 'q[duration_seconds_between][]', in: :query, type: :integer, required: false, description: "Filter by duration in seconds between given value begin. (e.g., '3600' for 1 hour, '32400' for 9 hours)"
      parameter name: 'q[duration_seconds_between][]', in: :query, type: :integer, required: false, description: "Filter by duration in seconds between given value end. (e.g., '3600' for 1 hour, '32400' for 9 hours)"

      response '200', 'sleep records found' do
        schema type: :object,
          properties: {
            sleep_records: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer, example: 322 },
                  sleep_time: { type: :string, format: :'date-time', example: "2025-09-12T08:47:59.153Z" },
                  awake_time: { type: :string, format: :'date-time', nullable: true, example: "2025-09-12T16:47:59.153Z" },
                  duration_seconds: { type: :integer, example: 28800 },
                  sleep_duration: {
                    type: :object,
                    properties: {
                      hour: { type: :hour, nullable: true, example: 8 },
                      minute: { type: :hour, nullable: true, example: 0 },
                      second: { type: :integer, nullable: true, example: 0 }
                    }
                  },
                  user: {
                    type: :object,
                    properties: {
                      id: { type: :integer, example: 1 },
                      name: { type: :string, example: "Damion Greenfelder" },
                      last_30_days_sleep_summaries: {
                        type: :object,
                        properties: {
                          total_sleep_duration: {
                            type: :object,
                            properties: {
                              hour: { type: :hour },
                              minute: { type: :hour },
                              second: { type: :integer }
                            }
                          },
                          average_sleep_duration: {
                            type: :object,
                            properties: {
                              hour: { type: :hour, nullable: true },
                              minute: { type: :hour, nullable: true },
                              second: { type: :integer, nullable: true }
                            }
                          },
                          average_sleep_quality_score: { type: :number, example: 8 }
                        }
                      },
                      created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:29.071Z" }
                    }
                  },
                  created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:32.967Z" }
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

        let(:user) { create(:user, :with_sleep_records) }
        let(:user_id) { user.id }
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/sleep_records/following' do
    get 'Retrieves all sleep records from followed users' do
      tags 'Sleep Records'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :string, example: 1
      parameter name: :page, in: :query, type: :integer, required: false, example: 1
      parameter name: :per_page, in: :query, type: :integer, required: false, example: 10
      parameter name: 'q[id_eq]', in: :query, type: :integer, required: false
      parameter name: 'q[sleep_time_gteq]', in: :query, type: :string, format: 'date-time', required: false, description: "Filter by sleep time greater than or equal to a given datetime. (e.g., '2025-09-09 23:52:01')"
      parameter name: 'q[sleep_time_lteq]', in: :query, type: :string, format: 'date-time', required: false, description: "Filter by sleep time less than or equal to a given datetime. (e.g., '2025-09-10 09:21:00')"
      parameter name: 'q[sleep_time_between][]', in: :query, type: :string, format: 'date-time', required: false, description: "Filter by sleep time between given datetime begin. (e.g., '2025-09-10 09:21:00')"
      parameter name: 'q[sleep_time_between][]', in: :query, type: :string, format: 'date-time', required: false, description: "Filter by sleep time between given datetime end. (e.g., '2025-09-10 09:23:00')"
      parameter name: 'q[awake_time_gteq]', in: :query, type: :string, format: 'date-time', required: false, description: "Filter by awake time greater than or equal to a given datetime. (e.g., '2025-09-09 23:52:01')"
      parameter name: 'q[awake_time_lteq]', in: :query, type: :string, format: 'date-time', required: false, description: "Filter by awake time less than or equal to a given datetime. (e.g., '2025-09-10 09:21:00')"
      parameter name: 'q[awake_time_between][]', in: :query, type: :string, format: 'date-time', required: false, description: "Filter by awake time betweeen given datetime begin. (e.g., '2025-09-10 09:21:00')"
      parameter name: 'q[awake_time_between][]', in: :query, type: :string, format: 'date-time', required: false, description: "Filter by awake time betweeen given datetime end. (e.g., '2025-09-10 10:00:00')"
      parameter name: 'q[duration_seconds_gteq]', in: :query, type: :integer, required: false, description: "Filter by duration in seconds greater than or equal to a given value."
      parameter name: 'q[duration_seconds_lteq]', in: :query, type: :integer, required: false, description: "Filter by duration in seconds less than or equal to a given value."
      parameter name: 'q[duration_seconds_between][]', in: :query, type: :integer, required: false, description: "Filter by duration in seconds between given value begin. (e.g., '3600' for 1 hour, '32400' for 9 hours)"
      parameter name: 'q[duration_seconds_between][]', in: :query, type: :integer, required: false, description: "Filter by duration in seconds between given value end. (e.g., '3600' for 1 hour, '32400' for 9 hours)"

      let(:user) { create(:user, :with_sleep_records) }
      let(:user_id) { user.id }
      response '200', 'sleep records found' do
        schema type: :object,
          properties: {
            sleep_records: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer, example: 322 },
                  sleep_time: { type: :string, format: :'date-time', example: "2025-09-12T08:47:59.153Z" },
                  awake_time: { type: :string, format: :'date-time', nullable: true, example: "2025-09-12T16:47:59.153Z" },
                  duration_seconds: { type: :integer, example: 28800 },
                  sleep_duration: {
                    type: :object,
                    properties: {
                      hour: { type: :hour, nullable: true, example: 8 },
                      minute: { type: :hour, nullable: true, example: 0 },
                      second: { type: :integer, nullable: true, example: 0 }
                    }
                  },
                  user: {
                    type: :object,
                    properties: {
                      id: { type: :integer, example: 1 },
                      name: { type: :string, example: "Damion Greenfelder" },
                      last_30_days_sleep_summaries: {
                        type: :object,
                        properties: {
                          total_sleep_duration: {
                            type: :object,
                            properties: {
                              hour: { type: :hour },
                              minute: { type: :hour },
                              second: { type: :integer }
                            }
                          },
                          average_sleep_duration: {
                            type: :object,
                            properties: {
                              hour: { type: :hour, nullable: true },
                              minute: { type: :hour, nullable: true },
                              second: { type: :integer, nullable: true }
                            }
                          },
                          average_sleep_quality_score: { type: :number, example: 8 }
                        }
                      },
                      created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:29.071Z" }
                    }
                  },
                  created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:32.967Z" }
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

        let(:other_user) { create(:user, :with_sleep_records) }
        let(:follow) { create(:follow, follower: user, followed: other_user) }
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/sleep_records/{id}' do
    get 'Retrieves a sleep record' do
      tags 'Sleep Records'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :string, example: 1
      parameter name: :id, in: :path, type: :string

      response '200', 'sleep record found' do
        schema type: :object,
          properties: {
            sleep_record: {
              type: :object,
              properties: {
                id: { type: :integer, example: 1 },
                sleep_time: { type: :string, format: :'date-time', example: "2024-10-26T23:52:00.000Z" },
                awake_time: { type: :string, format: :'date-time', nullable: true, example: "2024-10-27T10:41:00.000Z" },
                duration_seconds: { type: :integer, example: 38940 },
                sleep_duration: {
                  type: :object,
                  properties: {
                    hour: { type: :hour, example: 10.82 },
                    minute: { type: :hour, example: 649 },
                    second: { type: :integer, example: 38940 }
                  }
                },
                user: {
                  type: :object,
                  properties: {
                    id: { type: :integer, example: 1 },
                    name: { type: :string, example: "Damion Greenfelder" },
                    last_30_days_sleep_summaries: {
                      type: :object,
                      properties: {
                        total_sleep_duration: {
                          type: :object,
                          properties: {
                            hour: { type: :hour, example: 0 },
                            minute: { type: :hour, example: 0 },
                            second: { type: :integer, example: 0 }
                          }
                        },
                        average_sleep_duration: {
                          type: :object,
                          properties: {
                            hour: { type: :hour, nullable: true, example: nil },
                            minute: { type: :hour, nullable: true, example: nil },
                            second: { type: :integer, nullable: true, example: nil }
                          }
                        },
                        average_sleep_quality_score: { type: :number, example: 0 }
                      }
                    },
                    created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:29.071Z" }
                  }
                },
                created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:29.110Z" }
              }
            }
          }

        let(:user) { create(:user, :with_sleep_records) }
        let(:user_id) { user.id }
        let(:id) { user.sleep_records.first.id }
        run_test!
      end

      response '404', 'sleep record not found' do
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

  path '/api/v1/users/{user_id}/sleep_records/clock_in' do
    post 'Clocks in a sleep record' do
      tags 'Sleep Records'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :string, example: 1

      response '200', 'Clock In - Success' do
        schema type: :object,
          properties: {
            sleep_record: {
              type: :object,
              properties: {
                id: { type: :integer, example: 1 },
                sleep_time: { type: :string, format: :'date-time', example: "2024-10-26T23:52:00.000Z" },
                awake_time: { type: :string, format: :'date-time', nullable: true, example: "2024-10-27T10:41:00.000Z" },
                duration_seconds: { type: :integer, example: 38940 },
                sleep_duration: {
                  type: :object,
                  properties: {
                    hour: { type: :hour, nullable: true, example: 10.82 },
                    minute: { type: :hour, nullable: true, example: 649 },
                    second: { type: :integer, nullable: true, example: 38940 }
                  }
                },
                user: {
                  type: :object,
                  properties: {
                    id: { type: :integer, example: 1 },
                    name: { type: :string, example: "Damion Greenfelder" },
                    last_30_days_sleep_summaries: {
                      type: :object,
                      properties: {
                        total_sleep_duration: {
                          type: :object,
                          properties: {
                            hour: { type: :hour, example: 0 },
                            minute: { type: :hour, example: 0 },
                            second: { type: :integer, example: 0 }
                          }
                        },
                        average_sleep_duration: {
                          type: :object,
                          properties: {
                            hour: { type: :hour, nullable: true, example: nil },
                            minute: { type: :hour, nullable: true, example: nil },
                            second: { type: :integer, nullable: true, example: nil }
                          }
                        },
                        average_sleep_quality_score: { type: :number, example: 0 }
                      }
                    },
                    created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:29.071Z" }
                  }
                },
                created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:29.110Z" }
              }
            }
          }

        let(:user) { create(:user) }
        let(:user_id) { user.id }
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/sleep_records/clock_out' do
    put 'Clocks out a sleep record' do
      tags 'Sleep Records'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :string, example: 1

      response '200', 'Clock In - Success' do
        schema type: :object,
          properties: {
            sleep_record: {
              type: :object,
              properties: {
                id: { type: :integer, example: 1 },
                sleep_time: { type: :string, format: :'date-time', example: "2024-10-26T23:52:00.000Z" },
                awake_time: { type: :string, format: :'date-time', nullable: true, example: "2024-10-27T10:41:00.000Z" },
                duration_seconds: { type: :integer, example: 38940 },
                sleep_duration: {
                  type: :object,
                  properties: {
                    hour: { type: :hour, example: 10.82 },
                    minute: { type: :hour, example: 649 },
                    second: { type: :integer, example: 38940 }
                  }
                },
                user: {
                  type: :object,
                  properties: {
                    id: { type: :integer, example: 1 },
                    name: { type: :string, example: "Damion Greenfelder" },
                    last_30_days_sleep_summaries: {
                      type: :object,
                      properties: {
                        total_sleep_duration: {
                          type: :object,
                          properties: {
                            hour: { type: :hour, example: 0 },
                            minute: { type: :hour, example: 0 },
                            second: { type: :integer, example: 0 }
                          }
                        },
                        average_sleep_duration: {
                          type: :object,
                          properties: {
                            hour: { type: :hour, nullable: true, example: nil },
                            minute: { type: :hour, nullable: true, example: nil },
                            second: { type: :integer, nullable: true, example: nil }
                          }
                        },
                        average_sleep_quality_score: { type: :number, example: 0 }
                      }
                    },
                    created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:29.071Z" }
                  }
                },
                created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:29.110Z" }
              }
            }
          }

        let(:user) { create(:user) }
        let(:user_id) { user.id }
        before { create(:sleep_record, user: user, awake_time: nil) }
        run_test!
      end

      response '400', 'When no active clock in' do
        schema type: :object,
          properties: {
            error: { type: :string, example: 'No active sleep record found. Please clock in first.' }
          }
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        run_test!
      end
    end
  end
end
