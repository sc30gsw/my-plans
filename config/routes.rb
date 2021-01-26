Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end

  root to: 'notes#index'
  resources :users, only: [:show]
  resources :intros, only: [:new, :create, :edit, :update]

  # 新着順(投稿)を取得
  get 'notes/order_index', to: 'notes#order_index'

# いいねした投稿を表示するためのルーティング
  get 'notes/favorite/:id', to: 'notes#favorite'

  resources :notes do
    collection do
      get 'search'
    end
    collection do
      get 'note_search'
    end
  end

  # タグがつけられた投稿一覧のルーティング
  get 'tag/:id/notes', to: 'tags#note'
end
