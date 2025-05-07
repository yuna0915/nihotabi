Rails.application.routes.draw do
  # ユーザー用 Devise（認証関連）
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }
  # 一般ユーザー向けルーティング
  scope module: :public do
    root to: "homes#top"
    get 'about', to: 'homes#about'
    # ユーザー情報
    resource :user, only: [:edit, :update, :destroy] do
      get 'my_page'
      get 'show'
      get 'followings'
      get 'followers'
    end
    # 投稿機能
    resources :posts, only: [:new, :create, :show, :edit, :update, :destroy]
  end
end

