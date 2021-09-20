Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :replies
      resources :comments
      resources :likes
      resources :images
      resources :users
    end
  end
end
