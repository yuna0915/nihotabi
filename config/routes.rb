Rails.application.routes.draw do
  # ユーザー用
  # URL /customers/sign_in ...
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }
  # ゲストログイン用
  devise_scope :user do
    post 'guests/sign_in', to: 'public/sessions#guest_sign_in'
  end
  # 一般ユーザー向けルーティング
  scope module: :public do
    root to: "homes#top"
    get 'about', to: 'homes#about'
    get 'search', to: 'searches#search', as: 'search'
    # ユーザー情報
    resources :users, only: [:edit, :update, :show] do
      get 'my_page', on: :member
      get 'followings', on: :member
      get 'followers', on: :member
      patch 'withdraw', on: :member
    end    
    # 投稿機能
    resources :posts do
      resources :comments, only: [:create, :destroy]
    end
  end

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
end

