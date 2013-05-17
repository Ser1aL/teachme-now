Teachme::Application.routes.draw do

  get 'comments/create'

  resources :users, only: %w(show edit update) do
    resources :user_connections, only: %w(create) do
      delete :destroy, on: :collection
    end

    resources :ratings, only: %w(create) do
      put :update, on: :collection
    end

    get 'map_interest/:sub_interest_id', to: :map_interest, as: :map_interest
    get 'update-email', to: :update_email, as: :update_email

    # tabs for profile page
    get 'teacher_lessons'
    get 'student_lessons'
    get 'watchlist_lessons'

    constraints :connection_type => /followers|leaders/ do
      get 'connected_users/:connection_type', to: 'users#connected_users', as: :connected_users
    end

  end

  resources :comments, only: %w(create index)
  resources :image_attachments, only: %w(create)

  get 'vkontakte_transitional', to: 'users/omniauth_callbacks#vkontakte_transitional'

  resources :lessons, only: %w(show edit update create new index) do
    get 'new-lesson', on: :collection, to: :new_lesson, as: :new_lesson
    get 'new-lesson/:course_id', on: :collection, to: :new_lesson, as: :new_course_lesson
    get 'index_by_page', on: :collection, to: :index_by_page

    get 'i/:interest_id', to: 'lessons#index', as: :interest, on: :collection
    get 'i/:interest_id/:sub_interest_id', to: 'lessons#index', as: :sub_interest, on: :collection
  end

  get 'static/:page_name', to: 'static_pages#show', as: :static_page

  resources :courses, only: %w(show edit update create new index)
  resources :interests, only: %w(index)

  resources :passes, only: %w(create) do
    get 'buy/:lesson_id', on: :collection, to: 'passes#buy', as: :get_buy
    post 'buy', on: :collection
    get 'add_to_watchlist', on: :collection
  end

  devise_for :users, path_prefix: 'd', controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  get 'sitemap', controller: :sitemap, action: :index

  match '/404', to: 'errors#not_found'
  match '/500', to: 'errors#internal_server_error'

  root to: 'home#index'
end
