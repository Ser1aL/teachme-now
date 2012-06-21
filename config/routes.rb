Teachme::Application.routes.draw do
  get "omniauth_callbacks/facebook"

  get "omniauth_callbacks/vkontakte"

  resources :users, only: %w(show edit update)
  resources :lessons, only: %w(show edit update create new index)
  resources :interests, only: %w(index)
  devise_for :users, path_prefix: 'd', controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root to: 'home#index'
end
