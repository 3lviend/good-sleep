Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  require "sidekiq/web"
  require "sidekiq-scheduler/web"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  mount Sidekiq::Web, at: "/sidekiq"

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[ index show ] do
        resources :sleep_records, only: %i[ index show ] do
          collection do
            get   :following
            post  :clock_in
            match :clock_out, via: %i[ put patch ]
          end
        end
        resources :follows, only: %i[ index ] do
          collection do
            get    :followers
            get    :blocked
            post   :request_follow
            delete :unfollow
            match  :block_follower, via: %i[ put patch ]
            match  :unblock_follower, via: %i[ put patch ]
          end
        end
        resources :daily_sleep_summaries, only: %i[ index show ]
      end
    end
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
