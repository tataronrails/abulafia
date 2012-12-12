EOffice::Application.routes.draw do
  resources :column_orders


  resources :tasks, :has_many => :comments do
    post "add_new_comment" => "tasks#add_new_comment", :as => "add_new_comment"
    post "to_backlog" => "tasks#to_backlog", :as => "to_backlog"
    post "update_points" => "tasks#update_points", :as => "update_points"
    #post "update_order" => "tasks#update_order", :as => "update_order"
  end

  match "tasks/update_order" => "tasks#update_order"


  # resources :discussions, :has_many => :comments

  match "projects/:id/discussions/add_new_comment" => "discussions#add_new_comment", :as => "add_new_comment_to_discussion", :via => [:post]

  resources :discussions, :has_many => :comments

  resources :projects, :has_many => :comments do
    resources :discussions, :has_many => :comments
    post 'invite_user'
    get 'update_icebox'
    get 'update_backlog'
    get 'update_my_work'
    get "user_stories", "user_stories"
    #resource 'users'
  end


  devise_for :users, :controllers => {:invitations => 'users/invitations'} do
    get 'projects/:project_id/users' => 'projects#users_page', :as => "users_list"
    get 'projects/:project_id/:user_id/kick_out_users' => 'projects#kick_out_users', :as => "kick_out_users"

  end

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
  root :to => 'projects#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
