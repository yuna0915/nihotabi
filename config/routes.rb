Rails.application.routes.draw do
  namespace :public do
    get 'location_genres/show'
  end
  # ユーザー用 Devise
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  # ゲストログイン
  devise_scope :user do
    post 'guests/sign_in', to: 'public/sessions#guest_sign_in'
  end

  # 一般ユーザー向けルーティング
  scope module: :public do
    root to: "homes#top"
    get 'about', to: 'homes#about'
    get 'search', to: 'searches#search', as: 'search'
    get 'favorites', to: 'favorites#index', as: 'favorited_posts'

    resources :location_genres, only: [:show]

    resources :users, only: [:edit, :update, :show] do
      get 'my_page', on: :member
      get 'followings', on: :member
      get 'followers', on: :member
      patch 'withdraw', on: :member
    end

    resources :posts do
      resources :comments, only: [:create, :destroy]
      resource :favorite, only: [:create, :destroy]
    end
  end

  # 管理者用 Devise
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # 管理者向けルーティング
  namespace :admin do
    root to: 'homes#top'

    get 'search', to: 'searches#search', as: 'search'
    get 'master_data', to: 'master_data#index'

    get 'prefectures/edit', to: 'prefectures#edit', as: 'edit_prefectures'
    get 'location_genres/edit', to: 'location_genres#edit', as: 'edit_location_genres'
    get 'visited_months/edit', to: 'visited_months#edit', as: 'edit_visited_months'
    get 'visited_time_zones/edit', to: 'visited_time_zones#edit', as: 'edit_visited_time_zones'

    patch 'prefectures/:id/toggle_active', to: 'prefectures#toggle_active', as: 'toggle_active_prefecture'
    patch 'location_genres/:id/toggle_active', to: 'location_genres#toggle_active', as: 'toggle_active_location_genre'
    patch 'visited_months/:id/toggle_active', to: 'visited_months#toggle_active', as: 'toggle_active_visited_month'
    patch 'visited_time_zones/:id/toggle_active', to: 'visited_time_zones#toggle_active', as: 'toggle_active_visited_time_zone'

    resources :prefectures, only: [:create, :update, :destroy]
    resources :location_genres, only: [:create, :update, :destroy]
    resources :visited_months, only: [:create, :update, :destroy]
    resources :visited_time_zones, only: [:create, :update, :destroy]

    resources :users, only: [:show, :edit, :update] do
      patch :withdraw, on: :member
    end
    resources :posts, only: [:index, :show, :destroy]
    resources :comments, only: [:index, :destroy]
  end
end
