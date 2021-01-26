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


  resources :notes do
    resources :favorites, only: %i[create destroy]
    resources :comments, only: [:create]
    collection do
      get 'search'
    end
    collection do
      get 'note_search'
    end
  end

  # フォロー機能のルーティング
  resources :relationships, only: %i[create destroy]

  # 通知機能のルーティング
  resources :notifications, only: %i[index destroy]

  # DM機能のルーティング
  resources :messages, only: [:create]
  resources :rooms, only: %i[create show destroy]

  # タグがつけられた投稿一覧のルーティング
  get 'tag/:id/notes', to: 'tags#note'

  # いいねした投稿を表示するためのルーティング
  get 'notes/favorite/:id', to: 'notes#favorite'
  
  # いいねしてくれたユーザーを表示するためのルーティング
  get 'favorites/user/:id', to: 'favorites#user'

  # コメントした投稿を表示するためのルーティング
  get 'comments/user/:id', to: 'comments#user'

  # コメント削除機能のルーティング
  resources :comments, only: [:destroy]

  # フォローしているユーザー一覧のルーティング
  get 'followings/user/:id', to: 'relationships#followings'

  # フォロワー一覧のルーティング
  get 'followers/user/:id', to: 'relationships#followers'

  # ユーザーのメモページへのルーティング
  get 'memos/user/:id', to: 'memos#index'

  # メモ既読機能
  get 'memos/:id', to: 'memos#checked'

  resources :memos, only: %i[create destroy]
end
