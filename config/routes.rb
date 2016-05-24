Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
  resources :questions do
    resources :answers, shallow: true, except: [:index, :show, :new] do
      member do
        patch :best
      end
    end
  end
  root to: "questions#index"
end
