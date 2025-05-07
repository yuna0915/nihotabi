Rails.application.routes.draw do
  # ユーザー用 Devise
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  # ユーザー用
  scope module: :public do
    root to: "homes#top"
    get 'about', to: 'homes#about'
    get 'users/my_page', to: 'users#my_page', as: 'users_my_page'
    get 'users/edit', to: 'users#edit'
    get 'users/show', to: 'users#show'
    patch 'users/update', to: 'users#update'
    delete 'users/destroy', to: 'users#destroy'
    get 'users/followings', to: 'users#followings'
    get 'users/followers', to: 'users#followers'
  end
end
