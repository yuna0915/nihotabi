Rails.application.routes.draw do
  scope module: :public do
    root to: "homes#top"
    get 'about' , to: 'homes#about'
  end
end
