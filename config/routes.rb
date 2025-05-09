Rails.application.routes.draw do
  # ユーザー用 Devise（認証関連）
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
    # ユーザー情報
    resources :users, only: [:edit, :update, :show] do
      get 'my_page', on: :member
      get 'followings', on: :member
      get 'followers', on: :member
      patch 'withdraw', on: :member
    end    
    # 投稿機能
    resources :posts
  end
end

