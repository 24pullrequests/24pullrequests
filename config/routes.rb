Tfpullrequests::Application.routes.draw do
  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unprocessable'
  get '/500', to: 'errors#internal'

  get '/locale/:locale', to: 'dashboards#locale', as: :locale
  resources :gifts, except: [:show]
  resources :users, only: [:show, :index]

  resources :organisations, only: [:show, :index]

  get '/mergers', to: 'users#mergers', as: :mergers
  get '/users/:id', to: 'users#show'
  get '/users/unsubscribe/:token', to: 'users#unsubscribe', as: :user_unsubscribe

  resources :events

  resources :projects do
    collection do
      get :autofill
      post :claim
    end
    member do
      put :reactivate
    end
  end

  resources :contributions do
    collection do
      get :meta
    end
  end

  resources :pull_requests, only: [:index], controller: 'contributions' do
    collection do
      get :meta
    end
  end

  resource :dashboard, only: [:show, :destroy] do
    member do
      get :delete
      delete :destroy
    end
  end
  resource :pull_request_download, only: :create

  get '/resend_confirmation', to: 'dashboards#resend_confirmation_email', as: 'resend_confirmation'
  get '/confirm/:confirmation_token', to: 'dashboards#confirm_email', as: 'confirm_email'

  get '/preferences', to: 'dashboards#preferences', as: 'preferences'
  patch '/preferences/update', to: 'dashboards#update_preferences', as: 'update_preferences'
  get :my_suggestions, to: 'users#projects', as: :my_suggestions

  get '/login',  to: 'sessions#new',     as: 'login'
  get '/logout', to: 'sessions#destroy', as: 'logout'

  get '/contributors/map', to: 'contributor_map#show'

  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  get '/auth/failure',             to: 'sessions#failure'


  get 'about', to: 'static#about'
  get 'sponsors' => redirect('/about') # old sponsors url
  get 'humans', to: 'static#humans'
  get 'api', to: 'static#api'
  get 'contributing', to: 'static#contributing'
  get '2018', to: 'static#2018'

  get '/unsubscribe', to: 'unsubscribes#new', as: :unsubscribe
  post '/unsubscribe', to: 'unsubscribes#create'

  resources :languages, only: [:show] do
    member do
      get :projects
      get :pull_requests
      get :users
    end
  end

  root to: 'static#homepage'

  get '/email' => redirect('/preferences') # old preferences URL

  get '/:id' => redirect('/users/%{id}') # User public vanity url, must be lowest priority

  namespace :admin do
    post '/dasher', to: 'dasher#new_pull_request'
    resources :projects, only: [:index, :edit, :update, :destroy]
  end
end
