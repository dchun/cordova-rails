CordovaRails::Application.routes.draw do
  root 'jobs#new'
  
  get 'register' => 'users#new', :as => :register
  get 'login' => 'users#login', :as => :login
  post 'login' => 'users#create_session', :as => :create_session
  get 'logout' => 'users#logout', :as => :logout

  resources :users
  resources :jobs
  resources :images
end
