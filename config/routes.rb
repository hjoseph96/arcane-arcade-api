Rails.application.routes.draw do
  root 'home#index'
  namespace :v1 do
    post    '/login',       to: 'sessions#create'
    get     '/logged_in',   to: 'sessions#is_logged_in?'
    post    '/send_auth_token', to: 'sessions#send_auth_token'
    post    '/authorize',   to: 'sessions#authorize'

    resources :users, only: %i(show create update)

    get   '/onboarding/phase',  to: 'onboarding#show'
    post   '/onboarding/phase', to: 'onboarding#update'

    resources :notifications, only: [:index, :create] do
      member do
        match :mark_as_read, via: [:put, :patch]
      end
    end

    resources :listings, only: [:index, :show, :new, :create, :update] do
      collection do
        get :seller_listings
      end
      member do
        post :add_distributions
      end
      resources :supported_platform_listings, only: [:update]
    end

    resources :orders, only: %i(index show create) do
      member do
        get   :payment_status
        post  :unconfirmed
        post  :in_escrow
        post  :completed
        put :paid
      end
    end

    resources :owned_games, only: %i(index show)

    # TODO: You don't need nested seller here with params
    # like /sellers/:id/dashboard
    # as you can get the seller in the controller with current_user.seller
    # so you can change to routes to be /sellers/dashboard
    # same for earnings
    resources :sellers, only: [:show, :create] do
      member do
        get :dashboard
        get :earnings
      end
      collection do
        match :destination_addresses, via: [:put, :patch]
      end
    end

    mount Shrine.presign_endpoint(:cache) => "/s3/params"
    mount Shrine.presign_endpoint(:secure_cache) => "/s3/secure/params"
  end
end
