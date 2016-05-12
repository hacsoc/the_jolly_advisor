Rails.application.routes.draw do
  root 'courses#index'

  resources :users, only: [] do
    collection do
      get :login
      get :logout
    end
  end

  resources :courses, only: [:index, :show] do
    collection do
      get :autocomplete
    end
  end

  resources :course_instances, only: [] do
    collection do
      get :autocomplete
    end
  end

  resources :professors, only: [] do
    collection do
      get :autocomplete
    end
  end

  get 'scheduler' => 'scheduler#index'
  post 'scheduler' => 'scheduler#create'
  delete 'scheduler' => 'scheduler#destroy'
  get 'wishlist' => 'wishlist#index'
  post 'wishlist' => 'wishlist#add_course'
  put 'wishlist' => 'wishlist#update'
  delete 'wishlist' => 'wishlist#remove_course'
  get 'faq' => 'site#faq'
  get 'about' => 'site#about'
end
