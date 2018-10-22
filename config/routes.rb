Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users do
    post 'toggle_activity', on: :member
  end
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  resources :places, only: [:index, :show, :search]
  resources :styles
  root 'breweries#index'
  get 'kaikki_bisset', to: 'beers#index'
  get 'signup', to: 'users#new'
  get 'ratings', to: 'ratings#index'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  get 'join_club', to: 'memberships#new'
  get 'clubs', to: 'beer_clubs#index'
  post 'places', to:'places#search'
  get 'styles', to:'styles#index'
  get 'beerlist', to:'beers#list'
  get 'brewerylist', to:'breweries#list'
  get 'auth/:provider/callback', to: 'sessions#create_oauth'
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
