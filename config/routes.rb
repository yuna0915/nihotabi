Rails.application.routes.draw do
  namespace :admin do
    get 'comments/index'
    get 'comments/destroy'
  end
  # ユーザー用
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

    resources :users, only: [:edit, :update, :show] do
      get 'my_page', on: :member
      get 'followings', on: :member
      get 'followers', on: :member
      patch 'withdraw', on: :member
    end

    resources :posts do
      resources :comments, only: [:create, :destroy]
    end
  end

  # 管理者用
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    root to: 'homes#top'

    resources :users, only: [:show, :edit, :update] do
      patch :withdraw, on: :member
    end
    resources :comments, only: [:index, :destroy]
  end
end
