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
  # I merged your two 'resources :profiles' blocks here:
  resources :profiles, only: [:index, :show, :edit, :update, :destroy] do
    member do
      post :select # Creates: POST /profiles/:id/select
      post :add_page
    end
  end


  resources :characters do
    get :try_again, on: :member
  end


  # 4. Dashboard
  get 'dashboard', to: 'dashboard#index'

  # 5. Game Flow (Story Creation)
  # We use 'collection' for select because we submit a form with a hidden ID
  resources :characters, only: [:index, :show, :new, :create] do
    collection do
      post :select # Creates: POST /characters/select
    end
  end

  resources :universes, only: [:index, :show, :new, :create] do
    collection do
      post :select # Creates: POST /universes/select
    end
  end

  # 6. Playing the Story
  resources :stories, only: [ :new, :create, :show, :index ] do
    resources :chats, only: [:create, :show]
    member do
      post :bookmark
      get :print
      post :add_page
    end
  end

  resources :bookmarks, only: [:create, :destroy]

  # 7. System
  get "up" => "rails/health#show", as: :rails_health_check
end
