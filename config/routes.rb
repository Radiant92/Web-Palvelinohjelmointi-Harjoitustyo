Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  root 'breweries#index'
  get 'kaikki_bisset', to: 'beers#index'
  get 'signup', to: 'users#new'
  get 'ratings', to: 'ratings#index'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  get 'join_club', to: 'memberships#new'
  get 'clubs', to: 'beer_clubs#index'
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
