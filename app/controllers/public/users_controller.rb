class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:edit, :update, :withdraw]
  before_action :ensure_correct_user, only: [:edit, :update, :withdraw]

  def my_page
    @user = User.find_by(id: params[:id])
    if @user.nil?
      redirect_to root_path, alert: "ユーザーが見つかりませんでした。"
    else
      @posts = @user.posts.order(created_at: :desc)
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "情報を更新しました。"
    else
      render :edit
    end
  end

  def withdraw
    @user = User.find(params[:id])
    @user.update(is_active: false)
    reset_session
    redirect_to new_user_registration_path, notice: "退会が完了しました。"
  end

  def followings
    # 実装予定
  end

  def followers
    # 実装予定
  end

  private

  def user_params
    params.require(:user).permit(
      :last_name, :first_name, :last_name_kana, :first_name_kana,
      :nickname, :email, :phone_number, :prefecture,
      :introduction, :image
    )
  end

  def ensure_correct_user
    user = User.find(params[:id])
    if user != current_user
      redirect_to root_path, alert: "不正なアクセスです。"
    end
  end

  def ensure_guest_user
    user = User.find(params[:id])
    if user.email == "guest@example.com"
      redirect_to my_page_user_path(current_user), notice: "ゲストユーザーはこの操作を行えません。"
    end
  end
end
