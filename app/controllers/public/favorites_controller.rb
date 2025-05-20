# app/controllers/public/favorites_controller.rb
class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:index]

  def index
    if params[:user_id].present? && params[:user_id].to_i != current_user.id
      flash[:alert] = "他ユーザーのお気に入り一覧は閲覧できません。"
      redirect_to my_page_user_path(current_user) and return
    end
  
    @favorited_posts = current_user.favorited_posts.sorted(params[:sort]).page(params[:page])
  end

  def create
    @post = Post.find(params[:post_id])
    current_user.favorites.create(post: @post) 
  
    respond_to do |format|
      format.js
      format.html { redirect_back fallback_location: root_path }
    end
  end
  
  
  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite&.destroy
  
    respond_to do |format|
      format.js
      format.html { redirect_back fallback_location: root_path }
    end
  end

  private

  def ensure_correct_user
    if params[:user_id].present? && params[:user_id].to_i != current_user.id
      flash[:alert] = "他ユーザーのお気に入り一覧は閲覧できません。"
      redirect_to my_page_user_path(current_user)
    end
  end
end
