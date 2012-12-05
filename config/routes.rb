Gather::Application.routes.draw do
  resources :sources
  resources :articles do
    get :stash
  end
  resources :stashes
  resources :identities
  match 'manage' => 'articles#manage'
  match "/auth/:provider/callback", to: "sessions#create"
  match "/auth/failure", to: "sessions#failure"
  match "/logout", to: "sessions#destroy", :as => "logout"
  match "/login", to: "sessions#new"
  
  root :to => 'articles#index'
end