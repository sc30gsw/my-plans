Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }
  root to: 'notes#index'
  resources :users, only: [:show]
  resources :intros, only: [:new, :create, :edit, :update]
end
