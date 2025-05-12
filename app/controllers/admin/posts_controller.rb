class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts = Post.includes(:user).order(created_at: :desc)
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
