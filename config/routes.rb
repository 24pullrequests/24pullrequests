Tfpullrequests::Application.routes.draw do
  resources :users
  resources :projects, :only => [:index, :new, :create]
  resources :pull_requests, :only => [:index]
  resource  :dashboard # Singular, only applies to current user
  resource  :pull_request_download, :only => :create

  match '/email', to: 'dashboards#email', as: 'email'
  match '/email/update', to: 'dashboards#update_email', as: 'update_email'

  match '/login',  to: 'sessions#new',     as: 'login'
  match '/logout', to: 'sessions#destroy', as: 'logout'

  match '/auth/:provider/callback', to: 'sessions#create'
  match '/auth/failure',            to: 'sessions#failure'

  match 'about', :to => 'static#about'
  match 'contributing', :to => 'static#contributing'

  root :to => 'static#homepage'

  match '/:id', to: 'users#show' # User public vanity url, must be lowest priority
end
