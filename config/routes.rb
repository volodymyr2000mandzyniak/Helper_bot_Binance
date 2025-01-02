Rails.application.routes.draw do
  root "home#index"

  get 'binance_pairs', to: 'binance_pairs#index', as: 'binance_pairs_index'
  post 'binance_pairs/add_to_favorites', to: 'binance_pairs#add_to_favorites', as: 'add_to_favorites'


  resources :coins, only: [:index]
  resources :favorites, only: [:index, :destroy]
  get 'profile', to: 'profile#index', as: 'profile'

end
