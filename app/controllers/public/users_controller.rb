class Public::UsersController < ApplicationController
  def my_page
    @user = User.find_by(id: params[:id])
    if @user.nil?
      redirect_to root_path, alert: "ユーザーが見つかりませんでした"
      return
    end
    @posts = @user.posts.order(created_at: :desc)
  end
  

  def edit
    @user = current_user
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "情報を更新しました。"
    else
      render :edit
    end
  end  

  def withdraw
    current_user.update(is_active: false)
    reset_session
    redirect_to new_user_registration_path, notice: "退会が完了しました。"
  end

  def followings
  end

  def followers
  end

  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :nickname, :email, :phone_number, :prefecture)
  end
end
