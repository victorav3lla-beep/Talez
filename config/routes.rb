Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # Dashboard
  get 'dashboard', to: 'dashboard#index'

  # Resources
  resources :profiles, only: [:index, :show, :new, :create, :edit, :update]
  resources :characters, only: [:index, :show, :new, :create]
  resources :universes, only: [:index, :show, :new, :create]
  resources :stories do
    resources :chats, only: [:create, :show]
  end
  resources :bookmarks, only: [:create, :destroy]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
