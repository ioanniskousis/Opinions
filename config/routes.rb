Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "opinions#index"

  resources :sessions, only: [:new, :create, :destroy]

  resources :opinions, only: [:index, :new, :edit, :update, :create, :destroy]

  resources :users

  resources :followings, only: [:create, :destroy]

  resources :likes, only: [:create, :destroy]
end
