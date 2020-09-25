Rails.application.routes.draw do
  namespace :v1 do
    resources :users, only: %i(show create update)

    resources :sessions, only: %i(create destroy update) do
      member do
        post :authorize
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
