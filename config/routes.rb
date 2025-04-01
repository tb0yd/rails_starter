Rails.application.routes.draw do
  # Authentication routes
  get 'login', to: 'user_sessions#new', as: 'login'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy', as: 'logout'
  
  # Registration routes
  get 'register', to: 'registrations#new', as: 'register'
  post 'register', to: 'registrations#create'
  
  # Account switching
  get 'switch_account/:id', to: 'accounts#switch', as: 'switch_account'
  
  # User profile
  get 'profile', to: 'users#profile', as: 'profile'
  
  # Dashboard
  get 'dashboard', to: 'dashboard#index', as: 'dashboard'
  
  # Resources
  resources :users
  resources :accounts
  
  # Root path
  root to: 'dashboard#index'
end

