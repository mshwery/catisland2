Gather::Application.routes.draw do
  resources :sources

  resources :articles

  root :to => 'articles#index'
end
