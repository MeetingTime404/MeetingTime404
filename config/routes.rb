Rails.application.routes.draw do
  devise_for :users
  root 'pages#index'
  resources :games, only: [:new, :create, :show, :index] do
    resources :chess_pieces, only: [:create, :update, :show]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
