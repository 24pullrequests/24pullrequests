Tfpullrequests::Application.routes.draw do
  resources :users
  resources :projects, :only => [:index, :new, :create]
  resource  :dashboard # Singular, only applies to current user

  match '/preferences', to: 'dashboards#preferences', as: 'preferences'
  match '/preferences/update', to: 'dashboards#update_preferences', as: 'update_preferences'

  match '/login',  to: 'sessions#new',     as: 'login'
  match '/logout', to: 'sessions#destroy', as: 'logout'

  match '/auth/:provider/callback', to: 'sessions#create'
  match '/auth/failure',            to: 'sessions#failure'

  match 'about', :to => 'static#about'
  match 'contributing', :to => 'static#contributing'

  root :to => 'static#homepage'

  match '/email' => redirect('/preferences') # old preferences URL

  match '/:id' => redirect('/users/%{id}') # User public vanity url, must be lowest priority
end
