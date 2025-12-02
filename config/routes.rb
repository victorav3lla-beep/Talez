Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get 'dashboard', to: 'dashboard#index'

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

  resources :profiles, only: [:index, :show, :new, :create] do
    member do
      post :select
    end
  end 

  get "up" => "rails/health#show", as: :rails_health_check
end
