Rails.application.routes.draw do
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

  root 'search#index'

  get :search, to: 'search#index'
  post :search, to: 'search#search'

  namespace :api do
    namespace :v1 do
      get 'hello_world', to: 'hello_worlds#index'
      post 'weather', to: 'weathers#search'

      get 'location/:country', to: 'locations#states'
      get 'location/:country/:state', to: 'locations#cities'
    end
  end

  resources :users, only: [:new, :create]

  resources :user_sessions, only: [:create, :destroy]

  resources :resets, only: [:new, :create, :edit, :update]

  delete '/sign_out', to: 'user_sessions#destroy', as: :sign_out
  get '/sign_in', to: 'user_sessions#new', as: :sign_in
  get '/register', to: 'users#new', as: :register

  get '/account', to: 'users#password_reset', as: :account
  patch '/account', to: 'users#set_password', as: :account_save

  get '/details', to: 'preferences#details'
  post '/details', to: 'preferences#details_update', as: :detail_updates

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
