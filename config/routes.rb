Rails.application.routes.draw do
  # 1. Marketing / Public
  root to: "home#index"
  get 'home/index'

  # 2. Authentication
  devise_for :users

  # 3. Profiles Management
  # Nested route for creating a profile linked to a user (Le Wagon style)
  resources :users, only: [] do
    resources :profiles, only: [:new, :create]
  end

  # Standard routes for managing profiles + Selection logic
  resources :profiles, only: [:index, :show, :edit, :update, :destroy] do
    member do
      post :select
      post :add_page
    end
  end

  resources :characters do
    get :try_again, on: :member
  end

  resources :universes do
    get :try_again, on: :member
  end

  # 4. Dashboard
  get 'dashboard', to: 'dashboard#index'

  # 5. Game Flow (Story Creation)
  resources :characters, only: [:index, :show, :new, :create, :destroy] do
    collection do
      post :select
    end
  end

  resources :universes, only: [:index, :show, :new, :create, :destroy] do
    collection do
      post :select
    end
  end

  # 6. Playing the Story
  resources :stories, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :chats, only: [:create, :show]
    resources :likes, only: [:create]
    member do
      post :bookmark
      get :print
      post :add_page
      post :generate_story_cover
    end
  end

  resources :likes, only: [:destroy]
  resources :bookmarks, only: [:create, :destroy]

  # 7. System
  get "up" => "rails/health#show", as: :rails_health_check
end
