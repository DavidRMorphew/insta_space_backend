Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :replies
      resources :comments
      resources :likes
      resources :images, only: [:index]
      resources :users, only: [:create, :show]
      post '/login', to: 'auth#create'
      get '/logged_in', to: 'auth#logged_in'
      delete '/logout', to: 'auth#destroy'
    end
  end

  # match '*all', controller: 'application', action: 'cors_preflight_check', via: [:options]
end
