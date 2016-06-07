Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, only: [:index, :create, :update, :destroy], shallow: true, concerns: :votable do
      member do
        patch :best
      end
    end
  end
  root to: "questions#index"

  # Tets routes for concerns votable
  post "vote_up" => 'fakes#vote_up'
  post "vote_down" => 'fakes#vote_down'

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
end
