class Public::PostsController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  
  def index
  end

  def new
    @post = Post.new
    @user = current_user
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    # 未実装のplace関連フィールドにダミーを入れる（null: false対策）
    @post.place_id = "temp_place_id"
    @post.latitude = 0.0
    @post.longitude = 0.0
    if @post.save
      redirect_to my_page_user_path
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "投稿を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to my_page_user_path, notice: '投稿を削除しました。'
  end

  private

  def post_params
    params.require(:post).permit(
      :title,
      :body,
      :location_name,
      :address,
      :place_id,
      :latitude,
      :longitude,
      :image,
      :prefecture_id,
      :visited_month_id,
      :visited_time_zone_id,
      :location_genre_id
    )
  end

  def ensure_correct_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to root_path, alert: "権限がありません"
    end
  end

end
