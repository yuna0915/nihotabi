class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts = case params[:sort]
             when 'likes'
               Post.left_joins(:favorites)
                   .group(:id)
                   .includes(:user)
                   .order('COUNT(favorites.id) DESC')
             when 'title'
               Post.includes(:user)
                   .order(:title)
             else
               Post.includes(:user)
                   .order(created_at: :desc)
             end
  
    @posts = @posts.page(params[:page]).per(10)
  end
  

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:user)
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to admin_posts_path, notice: "投稿を削除しました。"
  end
end
