Gather::Application.routes.draw do
  resources :sources
  resources :articles
  match 'manage' => 'articles#manage'

  root :to => 'articles#index'
end
