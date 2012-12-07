Tfpullrequests::Application.routes.draw do
  match '/404', :to => 'errors#not_found'
  match '/422', :to => 'errors#unprocessable'
  match '/500', :to => 'errors#internal'

  resources :gifts
  resources :users
  resources :projects, :only => [:index, :new, :create]
  resources :pull_requests, :only => [:index]
  resource  :dashboard # Singular, only applies to current user
  resource  :pull_request_download, :only => :create

  match '/preferences', :to => 'dashboards#preferences', :as => 'preferences'
  match '/preferences/update', :to => 'dashboards#update_preferences', :as => 'update_preferences'

  match '/login',  :to => 'sessions#new',     :as => 'login'
  match '/logout', :to => 'sessions#destroy', :as => 'logout'

  match '/auth/twitter/callback',   :to => 'twitter#authorize'
  delete '/twitter/remove',         :to => 'twitter#remove'

  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure',            :to => 'sessions#failure'

  match 'about', :to => 'static#about'
  match 'contributing', :to => 'static#contributing'

  root :to => 'static#homepage'

  match '/email' => redirect('/preferences') # old preferences URL

  match '/:id' => redirect('/users/%{id}') # User public vanity url, must be lowest priority
end
