Teachme::Application.routes.draw do

  get "omniauth_callbacks/facebook"
  get "omniauth_callbacks/vkontakte"

  resources :users, only: %w(show edit update) do
    get "map_interest/:sub_interest_id", to: :map_interest, as: :map_interest
    get "update-email", to: :update_email, as: :update_email
    get "edit-password", to: :edit_password, as: :edit_password
  end
  resources :lessons, only: %w(show edit update create new index) do
    get "new-lesson", on: :collection, to: :new_lesson, as: :new_lesson
    constraints(:interest_id => /[0-9]+/) do
      get ":interest_name/:interest_id(/:page)", to: 'lessons#index', as: :interest, on: :collection
      get ":interest_name/:interest_id/:sub_interest_name/:sub_interest_id(/:page)", to: 'lessons#index', as: :sub_interest, on: :collection
    end
  end
  resources :courses, only: %w(show edit update create new index)
  resources :interests, only: %w(index)

  devise_for :users, path_prefix: 'd', controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root to: 'home#index'
end
