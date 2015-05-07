Rails.application.routes.draw do
  resources :reviews do
    member do
      put :upvote
      put :downvote
    end
  end

  root 'courses#index'

  resources :users, except: [:create, :new, :destroy] do
    collection do
      get :login
      get :logout
    end
  end

  resources :courses do
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

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
