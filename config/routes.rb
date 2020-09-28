Rails.application.routes.draw do
  namespace :v1 do
    resources :users, only: %i(show create update)

    post    '/login',       to: 'sessions#create'
    delete  '/logout',      to: 'sessions#destroy'
    get     '/logged_in',   to: 'sessions#is_logged_in?'
    post    '/send_auth_token/:user_id', to: 'sessions#send_auth_token'
    post    '/authorize/:user_id',   to: 'sessions#authorize'

    post  '/notify', to: 'notifications#create'
    get   '/notifications/:user_id', to: 'notifications#index'
    get   '/notifications/:id/mark_as_read', to: 'notification#mark_as_read'

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
