Rails.application.routes.draw do
  mount Jobler::Engine => "/jobler"

  resources :jobler_jobs, only: :show
end
