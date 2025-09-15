require 'rails_helper'
require 'swagger_helper'

describe 'Follows API', type: :request do
  path '/api/v1/users/{user_id}/follows' do
    get 'Retrieves all followed users for a user' do
      tags 'Follows'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :string, example: 1
      parameter name: :page, in: :query, type: :integer, required: false, example: 1
      parameter name: :per_page, in: :query, type: :integer, required: false, example: 10

      response '200', 'followed users found' do
        schema type: :object,
          properties: {
            following: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer, example: 2 },
                  name: { type: :string, example: "Alease Leffler" },
                  sleep_records: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        id: { type: :integer, example: 622 },
                        sleep_time: { type: :string, format: :'date-time', example: "2025-08-21T18:09:00.000Z" },
                        awake_time: { type: :string, format: :'date-time', example: "2025-08-22T11:48:00.000Z" },
                        duration_seconds: { type: :integer, example: 63540 },
                        sleep_duration: {
                          type: :object,
                          properties: {
                            hour: { type: :number, example: 17.65 },
                            minute: { type: :integer, example: 1059 },
                            second: { type: :integer, example: 63540 }
                          }
                        },
                        created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:36.181Z" }
                      }
                    }
                  },
                  created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:32.983Z" }
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
          create_list(:follow, 5, follower: user)
        end
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/follows/followers' do
    get 'Retrieves all followers for a user' do
      tags 'Follows'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :string, example: 1
      parameter name: :page, in: :query, type: :integer, required: false, example: 1
      parameter name: :per_page, in: :query, type: :integer, required: false, example: 10

      response '200', 'followers found' do
        schema type: :object,
          properties: {
            followers: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer, example: 1 },
                  name: { type: :string, example: "Damion Greenfelder" },
                  sleep_records: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        id: { type: :integer, example: 13 },
                        sleep_time: { type: :string, format: :'date-time', example: "2024-11-07T18:08:00.000Z" },
                        awake_time: { type: :string, format: :'date-time', example: "2024-11-08T11:46:00.000Z" },
                        duration_seconds: { type: :integer, example: 63480 },
                        sleep_duration: {
                          type: :object,
                          properties: {
                            hour: { type: :number, example: 17.63 },
                            minute: { type: :integer, example: 1058 },
                            second: { type: :integer, example: 63480 }
                          }
                        },
                        created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:29.354Z" }
                      }
                    }
                  },
                  created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:29.071Z" }
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
          create_list(:follow, 5, followed: user)
        end
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/follows/blocked' do
    get 'Retrieves all blocked users for a user' do
      tags 'Follows'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :string, example: 1
      parameter name: :page, in: :query, type: :integer, required: false, example: 1
      parameter name: :per_page, in: :query, type: :integer, required: false, example: 10

      response '200', 'blocked users found' do
        schema type: :object,
          properties: {
            blocked: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer, example: 1 },
                  name: { type: :string, example: "Damion Greenfelder" },
                  followable_summaries: {
                    type: :object,
                    properties: {
                      following_count: { type: :integer, example: 7 },
                      followers_count: { type: :integer, example: 0 },
                      followers_blocked_count: { type: :integer, example: 0 }
                    }
                  },
                  last_30_days_sleep_summaries: {
                    type: :object,
                    properties: {
                      total_sleep_duration: {
                        type: :object,
                        properties: {
                          hour: { type: :integer, example: 0 },
                          minute: { type: :integer, example: 0 },
                          second: { type: :integer, example: 0 }
                        }
                      },
                      average_sleep_duration: {
                        type: :object,
                        properties: {
                          hour: { type: :number, nullable: true, example: nil },
                          minute: { type: :integer, nullable: true, example: nil },
                          second: { type: :integer, nullable: true, example: nil }
                        }
                      },
                      average_sleep_quality_score: { type: :number, example: 0 }
                    }
                  },
                  created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:29.071Z" }
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
          create_list(:follow, 5, follower: user, blocked: true)
        end
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/follows/request_follow' do
    post 'Requests to follow a user' do
      tags 'Follows'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :user_id, in: :path, type: :string, example: 1
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          followed_user_id: { type: :integer }
        },
        required: [ 'followed_user_id' ]
      }

      response '200', 'follow request created' do
        schema type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                id: { type: :integer, example: 9 },
                name: { type: :string, example: "Kylie Rogahn" },
                followable_summaries: {
                  type: :object,
                  properties: {
                    following_count: { type: :integer, example: 0 },
                    followers_count: { type: :integer, example: 1 },
                    followers_blocked_count: { type: :integer, example: 0 }
                  }
                },
                last_30_days_sleep_summaries: {
                  type: :object,
                  properties: {
                    total_sleep_duration: {
                      type: :object,
                      properties: {
                        hour: { type: :integer, example: 0 },
                        minute: { type: :integer, example: 0 },
                        second: { type: :integer, example: 0 }
                      }
                    },
                    average_sleep_duration: {
                      type: :object,
                      properties: {
                        hour: { type: :number, nullable: true, example: nil },
                        minute: { type: :integer, nullable: true, example: nil },
                        second: { type: :integer, nullable: true, example: nil }
                      }
                    },
                    average_sleep_quality_score: { type: :number, example: 0 }
                  }
                },
                created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:55.837Z" }
              }
            },
            message: { type: :string, example: "Successfully followed Kylie Rogahn." }
          }
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        let(:followed_user) { create(:user) }
        let(:params) { { followed_user_id: followed_user.id } }
        run_test!
      end

      response '422', 'When user already follow or failed when follow user' do
        schema type: :object,
          properties: {
            error: { type: :string, example: 'Follower is already following this user' }
          }
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        let(:params) { { followed_user_id: user.id } }
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/follows/block_follower' do
    put 'Blocks a follower' do
      tags 'Follows'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :user_id, in: :path, type: :string, example: 1
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          follower_user_id: { type: :integer }
        },
        required: [ 'follower_user_id' ]
      }

      response '200', 'follower blocked' do
        schema type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                id: { type: :integer, example: 1 },
                name: { type: :string, example: "Damion Greenfelder" },
                followable_summaries: {
                  type: :object,
                  properties: {
                    following_count: { type: :integer, example: 7 },
                    followers_count: { type: :integer, example: 0 },
                    followers_blocked_count: { type: :integer, example: 0 }
                  }
                },
                last_30_days_sleep_summaries: {
                  type: :object,
                  properties: {
                    total_sleep_duration: {
                      type: :object,
                      properties: {
                        hour: { type: :integer, example: 0 },
                        minute: { type: :integer, example: 0 },
                        second: { type: :integer, example: 0 }
                      }
                    },
                    average_sleep_duration: {
                      type: :object,
                      properties: {
                        hour: { type: :number, nullable: true, example: nil },
                        minute: { type: :integer, nullable: true, example: nil },
                        second: { type: :integer, nullable: true, example: nil }
                      }
                    },
                    average_sleep_quality_score: { type: :number, example: 0 }
                  }
                },
                created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:29.071Z" }
              }
            },
            message: { type: :string, example: "Successfully blocked Damion Greenfelder." }
          }
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        let(:follower_user) { create(:user) }
        before { create(:follow, follower: follower_user, followed: user) }
        let(:params) { { follower_user_id: follower_user.id } }
        run_test!
      end

      response '404', 'follower not found' do
        schema type: :object,
          properties: {
            message: { type: :string, example: 'Record not found' }
          }
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        let(:params) { { follower_user_id: 'invalid' } }
        run_test!
      end

      response '422', 'follower not following the user' do
        schema type: :object,
          properties: {
            error: { type: :string, example: 'You are not followed by user Damion Greenfelder.' }
          }
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        let(:params) { { follower_user_id: create(:user).id } }
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/follows/unblock_follower' do
    put 'Unblocks a follower' do
      tags 'Follows'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :user_id, in: :path, type: :string, example: 1
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          follower_user_id: { type: :integer }
        },
        required: [ 'follower_user_id' ]
      }

      response '200', 'follower unblocked' do
        schema type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                id: { type: :integer, example: 1 },
                name: { type: :string, example: "Damion Greenfelder" },
                followable_summaries: {
                  type: :object,
                  properties: {
                    following_count: { type: :integer, example: 8 },
                    followers_count: { type: :integer, example: 0 },
                    followers_blocked_count: { type: :integer, example: 0 }
                  }
                },
                last_30_days_sleep_summaries: {
                  type: :object,
                  properties: {
                    total_sleep_duration: {
                      type: :object,
                      properties: {
                        hour: { type: :integer, example: 0 },
                        minute: { type: :integer, example: 0 },
                        second: { type: :integer, example: 0 }
                      }
                    },
                    average_sleep_duration: {
                      type: :object,
                      properties: {
                        hour: { type: :number, nullable: true, example: nil },
                        minute: { type: :integer, nullable: true, example: nil },
                        second: { type: :integer, nullable: true, example: nil }
                      }
                    },
                    average_sleep_quality_score: { type: :number, example: 0 }
                  }
                },
                created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:29.071Z" }
              }
            },
            message: { type: :string, example: "Successfully unblocked Damion Greenfelder." }
          }
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        let(:follower_user) { create(:user) }
        before { create(:follow, follower: follower_user, followed: user, blocked: true) }
        let(:params) { { follower_user_id: follower_user.id } }
        run_test!
      end

      response '404', 'follower not found' do
        schema type: :object,
          properties: {
            message: { type: :string, example: 'Record not found' }
          }
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        let(:params) { { follower_user_id: 'invalid' } }
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/follows/unfollow' do
    delete 'Unfollows a user' do
      tags 'Follows'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :string, example: 1
      parameter name: :followed_user_id, in: :query, type: :integer

      response '200', 'user unfollowed' do
        schema type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                id: { type: :integer, example: 9 },
                name: { type: :string, example: "Kylie Rogahn" },
                followable_summaries: {
                  type: :object,
                  properties: {
                    following_count: { type: :integer, example: 0 },
                    followers_count: { type: :integer, example: 0 },
                    followers_blocked_count: { type: :integer, example: 0 }
                  }
                },
                last_30_days_sleep_summaries: {
                  type: :object,
                  properties: {
                    total_sleep_duration: {
                      type: :object,
                      properties: {
                        hour: { type: :integer, example: 0 },
                        minute: { type: :integer, example: 0 },
                        second: { type: :integer, example: 0 }
                      }
                    },
                    average_sleep_duration: {
                      type: :object,
                      properties: {
                        hour: { type: :number, nullable: true, example: nil },
                        minute: { type: :integer, nullable: true, example: nil },
                        second: { type: :integer, nullable: true, example: nil }
                      }
                    },
                    average_sleep_quality_score: { type: :number, example: 0 }
                  }
                },
                created_at: { type: :string, format: :'date-time', example: "2025-09-12T07:38:55.837Z" }
              }
            },
            message: { type: :string, example: "Successfully unfollowed Kylie Rogahn." }
          }
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        let(:followed_user) { create(:user) }
        before { create(:follow, follower: user, followed: followed_user) }
        let(:followed_user_id) { followed_user.id }
        run_test!
      end

      response '404', 'follow not found' do
        schema type: :object,
          properties: {
            message: { type: :string, example: 'Record not found' }
          }
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        let(:followed_user_id) { 'invalid' }
        run_test!
      end
    end
  end
end
