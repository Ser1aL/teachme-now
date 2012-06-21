Teachme::Application.routes.draw do
  resources :users, only: %w(show edit update)
  resources :lessons, only: %w(show edit update create new index)
  resources :interests, only: %w(index)
  devise_for :users, path_prefix: 'd'

  root to: 'home#index'
end
