TBMS::Application.routes.draw do


  match '/status/:id' => 'log_messages#handle', :as => "status"
  match '/log/handle/:id' => 'log_messages#handle'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests
  match "profile/:id" => "emailaccounts#zip_of_id",  :as => :zip_by_id,
        :constraints => { :id => /\d+/ }
  match "profile/:id/ok" => "emailaccounts#was_successfully_updated",
        :constraints => { :id => /\d+/ }
  match "profile/:email" => "emailaccounts#zip_of_email",:as => :generate_id,
        :constraints => { :email => /.*@.*/ }


  match "/groups/:id/edit/set_params" => "groups#set_params"
  match "/user.current/upload" => "users#upload"

  match '/subaccounts/:id/delete' => 'emailaccounts#delete_subaccount', :as => :delete_subaccount
  match 'groups/:id/propagate' => 'groups#overwrite_member_configs', :as => :override_members

  resources :users
  resource :user, :as => 'account'
  resources :user_sessions 
  resources :emailaccounts
  resources :log_messages, :path => "/log"

  match "emailaccounts/:id/edit/set_params" => "emailaccounts#set_params"
  match "emailaccounts/:id/edit/information" => "emailaccounts#change_information"
  match 'emailaccounts/:id/groupsettings' => "emailaccounts#group_configuration", :as => :reset_account
  resources :groups
  
  match 'login' => "user_sessions#new",      :as => :login
  match 'logout' => "user_sessions#destroy", :as => :logout

  root :to => "emailaccounts#index"
end
