class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts = case params[:sort]
             when 'likes'
               Post.left_joins(:favorites)               # 投稿といいねを結合
                   .group(:id)                           # 投稿ごとに集計
                   .includes(:user)
                   .order('COUNT(favorites.id) DESC')    # いいね数多い順
             when 'title'
               Post.includes(:user)
                   .order(:title)                        # タイトルあいうえお順
             else
               Post.includes(:user)
                   .order(created_at: :desc)             # 新着順
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
