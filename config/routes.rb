Rails.application.routes.draw do
  resources :financial_accounts

  resources :account_types

  resources :users

  get 'static_pages/home'
  get    'login'   => 'users#login'
  post   'login'   => 'users#login'
  delete 'logout'   => 'users#logout'
  get    'registration'   => 'users#new'
  post   'registration'   => 'users#create'
  get    'profile'   => 'users#show'
  get    'edit-profile'   => 'users#edit'
  root   'static_pages#home'
  get    'forgot-password'   => 'users#forgot_password'
  post   'forgot-password'   => 'users#forgot_password'
  get 'reset-password/:access_token', to: 'users#reset_password', as: 'reset-password'
  post   'reset-password/:access_token'   => 'users#reset_password'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  

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
