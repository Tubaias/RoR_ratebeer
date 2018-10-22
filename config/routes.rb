Rails.application.routes.draw do
  resources :memberships do
    post 'toggle_confirmed', on: :member
  end
  resources :beer_clubs
  root 'breweries#index'
  resources :users do
    post 'toggle_banned', on: :member
  end
  resources :beers
  resources :styles
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :places, only: [:index, :show]

  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'

  post 'places', to:'places#search'

  get 'beerlist', to:'beers#list'
  get 'brewerylist', to:'breweries#list'
end