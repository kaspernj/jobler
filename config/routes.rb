Jobler::Engine.routes.draw do
  resources :downloads, only: :show
  resources :jobs, only: :show
end
