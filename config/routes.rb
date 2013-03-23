EOffice::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, :controllers => { invitations: 'users/invitations' } do
    get 'projects/:project_id/:user_id/kick_out_users' => 'projects#kick_out_users', :as => "kick_out_users"
    get 'projects/:project_id/:user_id/reinvite_user' => 'projects#reinvite_user', :as => "reinvite_user"
    post "contacts/:user_id/add_new_comment" => "contacts#add_new_comment", :as => "add_new_comment_to_contact"
  end

  resources :strikes
  resources :column_orders
  resources :comments
  resources :accounts
  resources :transactions
  resources :discussions, :has_many => :comments
  resources :activities, :only => :index

  match "tasks/update_order" => "tasks#update_order"
  get "story/:id" => "tasks#show", :as => "story_to_show"

  match "projects/:id/discussions/add_new_comment" => "discussions#add_new_comment", :as => "add_new_comment_to_discussion", :via => [:post]
  get 'progress' => "projects#progress", :as => "progress"


  get 'contacts' => "contacts#index", :as => "contacts_list"
  get 'contacts/:id' => "contacts#show", :as => "contact_page"
  post 'contacts/create_virtual_user' => "contacts#create_virtual_user", :as => "contact_create_virtual_user"
  delete 'contacts/:id' => "contacts#destroy", :as => "contact_destroy"

  resources :users, :only => :show do
    scope :module => :users do
      resources :tasks, :only => :index
    end
  end

  resources :projects, :except => [:new] do
    scope :module => :projects do
      resources :users, :only => :index
      resources :tasks, :except => [:new, :index] do
        post "add_new_comment" => "tasks#add_new_comment", :as => "add_new_comment"
        post "to_backlog" => "tasks#to_backlog", :as => "to_backlog"
        post "update_hours_spend_on_task" => "tasks#update_hours_spend_on_task", :as => "update_hours_spend_on_task"
        post "update_points" => "tasks#update_points", :as => "update_points"
        post "accept_to_start" => "tasks#accept_to_start", :as => "accept_to_start"
        post "finish_work" => "tasks#finish_work", :as => "finish_work"
        get "sms_ping" => "tasks#sms_ping", :as => "sms_ping"
      end
      resources :sprints, :except => [:new, :destroy, :edit] do
        member do
          get 'user_stories'
        end
      end
    end

    resources :discussions, :has_many => :comments
    post 'invite_user'
    get 'update_icebox'
    get 'update_backlog'
    get 'update_current_work'
    get "user_stories"
  end

  #get 'users/:id' => 'users#profile', :as => "user_profile"

  root :to => 'projects#index'
end
