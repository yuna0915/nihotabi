Rails.application.routes.draw do

  # ユーザー用 Devise
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  # ゲストログイン
  devise_scope :user do
    post 'guests/sign_in', to: 'public/sessions#guest_sign_in'
  end

  # ユーザー
  scope module: :public do
    root to: "homes#top"                                                  # トップページ
    get 'about', to: 'homes#about'                                        # アバウトページ

    get 'search', to: 'searches#search', as: 'search'                     # 検索機能
    get 'favorites', to: 'favorites#index', as: 'favorited_posts'         # いいね一覧
    get 'follow_feed', to: 'posts#follow_feed', as: 'follow_feed_posts'   # フォロー中投稿一覧

    # 通知（一覧／個別既読／全既読）
    resources :notifications, only: [:index] do
      member do
        patch :mark_as_read
      end
      collection do
        patch :mark_all_as_read
      end
    end

    # 場所ジャンル
    resources :location_genres, only: [:show]

    # ユーザー関連
    resources :users, only: [:edit, :update, :show] do
      get 'my_page', on: :member                         # マイページ表示
      get 'followings', on: :member                      # フォロー一覧
      get 'followers', on: :member                       # フォロワー一覧
      patch 'withdraw', on: :member                      # 退会処理
      resource :relationship, only: [:create, :destroy]  # フォロー／解除
    end

    # 投稿（いいね・コメント含む）
    resources :posts do
      resources :comments, only: [:create, :destroy]     # コメント機能
      resource :favorite, only: [:create, :destroy]      # いいね機能
    end

    # 問い合わせ（送信・閲覧）
    resources :inquiries, only: [:index, :show, :new, :create]

    # 利用規約
    resource :term, only: [:show]
  end

  # 管理者用 Devise
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # 管理者向けルーティング
  namespace :admin do
    root to: 'homes#top'

    get 'search', to: 'searches#search', as: 'search'          # 管理者用検索
    get 'master_data', to: 'master_data#index'                 # マスターデータ編集ページ

    # 各マスターデータ編集画面
    get 'prefectures/edit', to: 'prefectures#edit', as: 'edit_prefectures'
    get 'location_genres/edit', to: 'location_genres#edit', as: 'edit_location_genres'
    get 'visited_months/edit', to: 'visited_months#edit', as: 'edit_visited_months'
    get 'visited_time_zones/edit', to: 'visited_time_zones#edit', as: 'edit_visited_time_zones'

    # 各マスターデータの表示／非表示切替
    patch 'prefectures/:id/toggle_active', to: 'prefectures#toggle_active', as: 'toggle_active_prefecture'
    patch 'location_genres/:id/toggle_active', to: 'location_genres#toggle_active', as: 'toggle_active_location_genre'
    patch 'visited_months/:id/toggle_active', to: 'visited_months#toggle_active', as: 'toggle_active_visited_month'
    patch 'visited_time_zones/:id/toggle_active', to: 'visited_time_zones#toggle_active', as: 'toggle_active_visited_time_zone'

    # マスターデータのCRUD
    resources :prefectures, only: [:create, :update, :destroy]
    resources :location_genres, only: [:create, :update, :destroy]
    resources :visited_months, only: [:create, :update, :destroy]
    resources :visited_time_zones, only: [:create, :update, :destroy]

    # ユーザー管理
    resources :users, only: [:show, :edit, :update] do
      patch :withdraw, on: :member                       # 強制退会
    end

    # 投稿・コメント・通知の管理
    resources :posts, only: [:index, :show, :destroy]
    resources :comments, only: [:index, :destroy]
    resources :notifications, only: [:index]

    # 問い合わせ・返信の管理
    resources :inquiries, only: [:index, :show]
    resources :inquiry_replies, only: [:create]

    # 利用規約管理（編集／表示）
    resource :term, only: [:show, :edit, :update]
  end

  # エラーページ
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
