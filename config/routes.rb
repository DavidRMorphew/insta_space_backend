Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :replies
      resources :comments
      resources :likes
      resources :images
      resources :users
      post '/login', to: 'auth#create'
      get '/profile', to: 'users#profile'
      get '/auto_login', to: 'auth#auto_login'
    end
  end

  # match '*all', controller: 'application', action: 'cors_preflight_check', via: [:options]
end
