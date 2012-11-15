Tfpullrequests::Application.routes.draw do
  resource  :dashboard   # Singular, the logged in homepage for the current user
  resource  :profile do  # Singular, the editable profile for the current user
    get :add_email, :on => :member
  end

  match '/login',  to: 'sessions#new',     as: 'login'
  match '/logout', to: 'sessions#destroy', as: 'logout'

  match '/auth/:provider/callback', to: 'sessions#create'
  match '/auth/failure',            to: 'sessions#failure'

  root :to => 'static#homepage'

  match '/:id', to: 'users#show' # User public vanity url, must be lowest priority
end
