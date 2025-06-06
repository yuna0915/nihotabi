class Public::PostsController < ApplicationController
  # 投稿機能はログイン必須（詳細表示は例外）
  before_action :authenticate_user!, except: [:show]
  before_action :ensure_correct_post_user, only: [:edit, :update, :destroy]
  before_action :ensure_follow_feed_access, only: [:follow_feed]

  def index
    respond_to do |format|
      format.html do
        @posts = Post.sorted(params[:sort]).page(params[:page])
      end
      format.json do
        @posts = Post.includes(:user).all
      end
    end
  end  
  
  def follow_feed
    @posts = Post
               .where(user_id: current_user.following_ids)
               .sorted(params[:sort])
               .page(params[:page])
  end  

  def new
    @post = Post.new
    @user = current_user
  end

  def show
    @post = Post.find(params[:id])
    @post.increment!(:view_count)
    @comments = @post.comments.includes(:user)

    # 未ログインかつトップページ経由でない場合はログイン画面へリダイレクト
    unless user_signed_in? || params[:from] == "top"
      redirect_to new_user_session_path, alert: "投稿の詳細を見るにはログインまたは会員登録が必要です。"
    end
  end  

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
  
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
      redirect_to post_path(@post), notice: "投稿を更新しました。"
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
      :prefecture_id,
      :visited_month_id,
      :visited_time_zone_id,
      :location_genre_id,
      images: [],
      remove_image_ids: []
    )
  end

  def ensure_correct_post_user
    post = Post.find(params[:id])
    unless post.user == current_user
      redirect_to my_page_user_path(current_user), alert: "他人の投稿は編集できません。"
    end
  end

  # 他人のフォロー投稿一覧にアクセスした場合
  def ensure_follow_feed_access
    if params[:user_id].present? && params[:user_id].to_i != current_user.id
      redirect_to root_path, alert: "他ユーザーのフォロー投稿一覧は閲覧できません。"
    end
  end
end
