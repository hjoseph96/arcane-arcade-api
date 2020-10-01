Rails.application.routes.draw do
  namespace :v1 do
    post    '/login',       to: 'sessions#create'
    delete  '/logout',      to: 'sessions#destroy'
    get     '/logged_in',   to: 'sessions#is_logged_in?'
    post    '/send_auth_token', to: 'sessions#send_auth_token'
    post    '/authorize',   to: 'sessions#authorize'

    resources :users, only: %i(show create update)

    get   '/onboarding/phase',  to: 'onboarding#show'
    post   '/onboarding/phase', to: 'onboarding#update'
    post   '/onboarding/seller/create', to: 'onboarding#create'

    resources :notifications, only: [:index, :create] do
      member do
        match :mark_as_read, via: [:put, :patch]
      end
    end

    resources :listings, only: %i(index create update show destroy)

    resources :orders, only: %i(index show create) do
      member do
        post :unconfirmed
        post :in_escrow
        post :completed
      end
    end

    resources :owned_games, only: %i(index show)

    resources :sellers, only: :show do
      member do
        get :dashboard
        get :earnings
      end
    end

  end
end
