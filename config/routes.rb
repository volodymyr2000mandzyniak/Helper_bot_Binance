Rails.application.routes.draw do
  get "profile/index"
  root "home#index"

  get 'binance_pairs', to: 'binance_pairs#index', as: 'binance_pairs_index'
  post 'binance_pairs/add_to_favorites', to: 'binance_pairs#add_to_favorites', as: 'add_to_favorites'

  resources :favorites, only: [:index, :destroy]
  get 'profile', to: 'profile#index', as: 'profile'

end
