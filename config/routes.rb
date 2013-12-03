Tfpullrequests::Application.routes.draw do
  get '/404', :to => 'errors#not_found'
  get '/422', :to => 'errors#unprocessable'
  get '/500', :to => 'errors#internal'

  get "/locale/:locale", to: "dashboards#locale", as: :locale
  resources :gifts
  resources :users
  get '/users/:id/:year', :to => 'users#show'

  resources :projects, :only => [:index, :new, :create, :edit, :update, :destroy] do
    collection do
      get :filter
      post :claim
    end
  end

  resources :pull_requests, :only => [:index]
  resource  :dashboard do
    member do
      get :delete
      delete :destroy
    end
  end
  resource  :pull_request_download, :only => :create

  get '/confirm/:confirmation_token', to: 'dashboards#confirm_email', as: 'confirm_email'

  get   '/preferences',        :to => 'dashboards#preferences',        :as => 'preferences'
  patch '/preferences/update', :to => 'dashboards#update_preferences', :as => 'update_preferences'
  get :my_suggestions, to: 'users#projects', as: :my_suggestions

  get '/login',  :to => 'sessions#new',     :as => 'login'
  get '/logout', :to => 'sessions#destroy', :as => 'logout'

  get '/auth/twitter/callback',    :to => 'twitter#authorize'
  delete '/twitter/remove',         :to => 'twitter#remove'

  match '/auth/:provider/callback', :to => 'sessions#create', :via => [:get, :post]
  post '/auth/failure',             :to => 'sessions#failure'

  get 'about', :to => 'static#about'
  get 'api', :to => 'static#api'
  get 'contributing', :to => 'static#contributing'

  resources :languages do
    member do
      get :projects
      get :pull_requests
      get :users
    end
  end

  root :to => 'static#homepage'

  get '/email' => redirect('/preferences') # old preferences URL

  get '/:id' => redirect('/users/%{id}') # User public vanity url, must be lowest priority

  namespace :admin do
    resources :projects, only: [ :index, :edit, :update, :destroy ]
  end
end
