class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:edit, :update, :withdraw]     # ゲストは編集・退会不可
  before_action :ensure_correct_user, only: [:edit, :update, :withdraw]   # 他人の編集・退会は禁止

  def my_page
    @user = User.find_by(id: params[:id])
    if @user.nil?
      redirect_to root_path, alert: "ユーザーが見つかりませんでした。"
    else
      @posts = @user.posts.sorted(params[:sort]).page(params[:page])
    end
  end  

  def show
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to root_path, alert: "他人のプロフィール詳細は閲覧できません。"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "ユーザー情報を更新しました。"
      redirect_to user_path(@user)
    else
      flash.now[:alert] = "ユーザー情報の更新に失敗しました。入力内容をご確認ください。"
      render :edit
    end
  end  

  def withdraw
    @user = User.find(params[:id])
    @user.update(is_active: false)
    reset_session   # セッション情報リセット（ログアウト）
    redirect_to new_user_registration_path, notice: "退会が完了しました。"
  end

  def followings
    @user = User.find(params[:id])
    @users = User.where(id: @user.following_ids).sorted(params[:sort]).page(params[:page]).per(10)
    render 'public/users/follow_list', locals: { list_type: 'followings' }
  end
  
  def followers
    @user = User.find(params[:id])
    @users = User.where(id: @user.follower_ids).sorted(params[:sort]).page(params[:page]).per(10)
    render 'public/users/follow_list', locals: { list_type: 'followers' }
  end  

  private

  def user_params
    params.require(:user).permit(
      :last_name, :first_name, :last_name_kana, :first_name_kana,
      :nickname, :email, :phone_number, :prefecture_id,
      :introduction, :image
    )
  end  

  # 他人の情報にアクセスしようとした場合に拒否
  def ensure_correct_user
    user = User.find(params[:id])
    unless user == current_user
      redirect_to my_page_user_path(current_user), alert: "他人のユーザー情報は編集できません。"
    end
  end

  # ゲストユーザーの編集・退会を制限
  def ensure_guest_user
    user = User.find(params[:id])
    if user.email == "guest@example.com"
      redirect_to my_page_user_path(current_user), notice: "ゲストユーザーはこの操作を行えません。"
    end
  end
end
