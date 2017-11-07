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

  get 'scheduler' => 'scheduler#index'
  post 'scheduler' => 'scheduler#create'
  delete 'scheduler' => 'scheduler#destroy'
  get 'wishlist' => 'wishlist#index'
  post 'wishlist' => 'wishlist#add_course'
  put 'wishlist' => 'wishlist#update'
  delete 'wishlist' => 'wishlist#remove_course'
  get 'faq' => 'site#faq'
  get 'about' => 'site#about'

  direct(:university_bulletin) { 'http://bulletin.case.edu/' }
  direct(:university_regulations) { 'http://case.edu/ugstudies/academic-policies/academic-regulations/' }
  direct(:ugs_forms) { 'http://case.edu/ugstudies/forms/' }
  direct(:ugs_office_hours) { 'http://case.edu/ugstudies/walkin/' }
  direct(:ugs_deans) { 'http://case.edu/ugstudies/about-us/who-we-are/' }

  direct(:new_github_issue) { 'https://github.com/hacsoc/the_jolly_advisor/issues/new' }
  direct(:github_contributing_wiki) { 'https://github.com/hacsoc/the_jolly_advisor/wiki/Contributing' }

  direct(:feathub) { 'https://feathub.com/hacsoc/the_jolly_advisor' }
end
