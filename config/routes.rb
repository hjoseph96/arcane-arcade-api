Rails.application.routes.draw do
  root 'home#index'
  namespace :v1 do
    post    '/login',       to: 'sessions#create'
    get     '/logged_in',   to: 'sessions#is_logged_in?'
    post    '/send_auth_token', to: 'sessions#send_auth_token'
    post    '/authorize',   to: 'sessions#authorize'
    post    '/send_password_token', to: 'sessions#send_password_token'
    post    '/authorize_password_token', to: 'sessions#authorize_password_token'
    post    '/reset_password', to: 'sessions#reset_password'

    resources :users, only: %i(show create update)

    get   '/onboarding/phase',  to: 'onboarding#show'
    post   '/onboarding/phase', to: 'onboarding#update'

    resources :notifications, only: [:index, :create] do
      member do
        match :mark_as_read, via: [:put, :patch]
      end
    end

    resources :listings, only: %i(index show new create update) do
      collection do
        get :seller_listings
      end
      member do
        post :add_distributions
      end
      resources :supported_platform_listings, only: [:update]
    end

    resources :orders, only: %i(index show create)
    put 'orders/:escrow_address/paid', to: 'orders#paid'
    put 'orders/:escrow_address/complete', to: 'orders#complete'

    resources :owned_games, only: %i(index show)

    resource :sellers, only: [:show, :create] do
      get :stats
      match :destination_addresses, via: [:put, :patch]
    end

    mount Shrine.presign_endpoint(:cache) => "/s3/params"
    mount Shrine.presign_endpoint(:secure_cache) => "/s3/secure/params"
  end
end
