Tfpullrequests::Application.routes.draw do
  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unprocessable'
  get '/500', to: 'errors#internal'

  get '/locale/:locale', to: 'dashboards#locale', as: :locale
  resources :gifts, except: [:show]
  resources :users, only: [:show, :index]

  resources :organisations, only: [:show, :index]

  get '/users/:id/:year', to: 'users#show'

  resources :events

  resources :projects, only: [:index, :new, :create, :edit, :update, :destroy] do
    collection do
      get :filter
      post :claim
    end
  end

  resources :pull_requests, only: [:index] do
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

  get '/preferences',        to: 'dashboards#preferences',        as: 'preferences'
  patch '/preferences/update', to: 'dashboards#update_preferences', as: 'update_preferences'
  get :my_suggestions, to: 'users#projects', as: :my_suggestions

  get '/login',  to: 'sessions#new',     as: 'login'
  get '/logout', to: 'sessions#destroy', as: 'logout'

  get '/auth/twitter/callback',    to: 'twitter#authorize'
  delete '/twitter/remove',         to: 'twitter#remove'

  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  post '/auth/failure',             to: 'sessions#failure'

  post '/auth/coderwall',           to: 'coderwall#authorize', as: 'update_coderwall'

  get 'about', to: 'static#about'
  get 'sponsors', to: 'static#sponsors'
  get 'humans', to: 'static#humans'
  get 'api', to: 'static#api'
  get 'contributing', to: 'static#contributing'

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
    resources :projects, only: [:index, :edit, :update, :destroy]
  end
end
