Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :all, on: :collection
      end
      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create]
      end
    end
  end

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  resources :questions, concerns: :votable do
    resources :comments, only: :create
    resources :answers, only: [:index, :create, :update, :destroy], shallow: true, concerns: :votable do
      resources :comments, only: :create
      member do
        patch :best
      end
    end
  end
  root to: "questions#index"

  # Serve websocket cable requests in-process
  mount ActionCable.server => "/cable"

  get "/oauth_services/new_email_oauth", as: "new_email_oauth"
  post "/oauth_services/save_email_oauth", as: "save_email_oauth"
  get "/oauth_services/confirm_email", as: "confirm_email"
  get "/oauth_services/confirm_web", as: "confirm_web"
  post "/oauth_services/post_confirm_web", as: "post_confirm_web"

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
