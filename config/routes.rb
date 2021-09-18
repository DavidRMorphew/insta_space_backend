Rails.application.routes.draw do
  resources :replies
  resources :comments
  resources :likes
  resources :images
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
