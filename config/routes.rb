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

    resources :listings

    resources :orders, only: %i(index show create) do
      member do
        post :unconfirmed
        post :in_escrow
        post :completed
      end
    end

    resources :owned_games, only: %i(index show)

    resources :sellers, only: [:show, :create] do
      member do
        get :dashboard
        get :earnings
      end
    end

    mount Shrine.presign_endpoint(:cache) => "/s3/params"
  end
end
