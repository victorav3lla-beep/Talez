Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # Nested resources for profile creation
  resources :users, only: [] do
    resources :profiles, only: [:new, :create]
  end

  # Standard profile routes + Selection action
  resources :profiles, only: [:index, :show, :edit, :update] do
    member do
      post :select
    end
  end

  get 'dashboard', to: 'dashboard#index'

  # Game resources
  resources :characters, only: [:index, :show, :new, :create]
  resources :universes, only: [:index, :show, :new, :create]

  resources :stories do
    resources :chats, only: [:create, :show]
    member do
      post :bookmark
      get :print
    end
  end

  resources :bookmarks, only: [:create, :destroy]

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
