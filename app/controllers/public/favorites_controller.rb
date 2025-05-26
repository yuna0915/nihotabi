class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorited_posts = current_user.favorited_posts
                                    .sorted(params[:sort])
                                    .page(params[:page])
  end

  def create
    @post = Post.find(params[:post_id])
    current_user.favorites.create(post: @post)

    # 非同期リクエストに対応（create.js.erb）
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite&.destroy

    # 非同期リクエストに対応（destroy.js.erb）
    respond_to do |format|
      format.js
    end
  end
end
