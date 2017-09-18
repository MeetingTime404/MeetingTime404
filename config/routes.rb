Rails.application.routes.draw do
  devise_for :users
  root 'pages#index'
  resources :chess_pieces, only: :create
  resources :games, only: [:new, :create, :show, :index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
