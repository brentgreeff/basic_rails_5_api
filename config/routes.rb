Rails.application.routes.draw do

  root to: 'events#index'

  post 'login', to: 'authentications#create'

  resources :users
  resources :events
end
