Teachme::Application.routes.draw do

  resources :users, only: %w(show edit update) do
    get 'subscribe', to: 'user_connections#create', as: :subscribe
    get 'unsubscribe', to: 'user_connections#destroy', as: :unsubscribe

    resources :ratings, only: %w(create) do
      put :update, on: :collection
    end

    get 'map_interest/:sub_interest_id', to: :map_interest, as: :map_interest
    get 'update-email', to: :update_email, as: :update_email
    get 'interests', to: :interests, as: :interests

    # tabs for profile page
    get 'teacher_lessons'
    get 'student_lessons'
    get 'watchlist_lessons'

    # pro
    get 'pro', as: :pro, to: 'pro_subscriptions#new'
  end

  post '/create_pro', as: :create_pro, to: 'pro_subscriptions#create'

  resources :image_attachments, only: %w(create show) do
    post 'create_gallery_attachment', to: :create_gallery_attachment, on: :collection, as: :create_gallery_attachment
    put 'create_gallery_attachment', to: :create_gallery_attachment, on: :collection, as: :create_gallery_attachment
  end
  resources :file_attachments, only: %w(create)
  put 'file_attachments', to: 'file_attachments#create', as: :file_attachments
  get '/files/:id', to: 'file_attachments#show', as: :file_attachment

  resources :comments, only: %w(create index)

  get 'vkontakte_transitional', to: 'users/omniauth_callbacks#vkontakte_transitional'

  resources :lessons, only: %w(show edit update create new index) do
    get 'new-lesson', on: :collection, to: :new_lesson, as: :new_lesson
    get 'new-lesson/:course_id', on: :collection, to: :new_lesson, as: :new_course_lesson
    get 'index_by_page', on: :collection, to: :index_by_page

    get 'i/:interest_id', to: 'lessons#index', as: :interest, on: :collection
    get 'i/:interest_id/:sub_interest_id', to: 'lessons#index', as: :sub_interest, on: :collection
    get 'search', to: 'lessons#search', as: :search, on: :collection

    get 'page/:page', to: 'lessons#index', :on => :collection
  end

  resources :classes, only: %w(index) do
    get 'search', to: 'classes#search', as: :search, on: :collection
  end

  resources :teachers, only: %w(index) do
    get 'search', to: 'teachers#search', as: :search, on: :collection
    get ':order', to: 'teachers#index', as: :order, on: :collection
  end

  get 'static/:page_name', to: 'static_pages#show', as: :static_page
  post 'static/contacts', to: 'static_pages#feedback', as: :feedback

  resources :courses, only: %w(show edit update create new index)

  resources :passes, only: %w(create) do
    get 'buy/:lesson_id', on: :collection, to: 'passes#buy', as: :get_buy
    post 'buy', on: :collection
    get 'add_to_watchlist', on: :collection
  end

  namespace :admin do
    root to: 'sessions#new'
    resources :lessons, only: %w(index show update) do
      get :contact_teacher
      get :confirm
      get :unconfirm
      post :send_confirmation
      post :send_issues
    end
    resources :users, only: %w(index)
    resources :sessions, only: %w(new create) do
      get :sign_out, on: :collection
    end
  end

  devise_for :users, path_prefix: 'd', controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  get 'sitemap', controller: :sitemap, action: :index

  match '/404', to: 'errors#not_found'
  match '/500', to: 'errors#internal_server_error'

  root to: 'home#index'
end
