class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :ensure_correct_post_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:follow_feed]
  
  def index
    @posts = Post.includes(:user, image_attachment: :blob).order(created_at: :desc)
  end
  
  def follow_feed
    if params[:user_id].present? && params[:user_id].to_i != current_user.id
      redirect_to root_path, alert: "他ユーザーのフォロー投稿一覧は閲覧できません。" and return
    end
  
    @posts = Post.where(user_id: current_user.following_ids).order(created_at: :desc)
  end
  

  def new
    @post = Post.new
    @user = current_user
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:user)
    return unless user_signed_in?

    return if @post.user == current_user
  
    if params[:from] == "follow_feed" && current_user.following_ids.include?(@post.user_id)
      return
    end

    if params[:from] == "favorites" && current_user.favorited_posts.exists?(@post.id)
      return
    end

    redirect_to my_page_user_path(current_user), alert: "この投稿の詳細は閲覧できません。"
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    # 未実装のplace関連フィールドにダミーを入れる（null: false対策）
    @post.place_id = "temp_place_id"
    @post.latitude = 0.0
    @post.longitude = 0.0
    if @post.save
      redirect_to post_path(@post), notice: "投稿が完了しました。"
    else
      flash.now[:alert] = "投稿に失敗しました。"
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
  
    if @post.update(post_params)
      flash[:notice] = "投稿を更新しました。"
      redirect_to post_path(@post)
    else
      flash.now[:alert] = "投稿の更新に失敗しました。入力内容をご確認ください。"
      render :edit
    end
  end  

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to my_page_user_path(current_user), notice: '投稿を削除しました。'
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

  def ensure_correct_post_user
    post = Post.find(params[:id])
    unless post.user == current_user
      redirect_to my_page_user_path(current_user), alert: "他人の投稿は編集できません。"
    end
  end

end
