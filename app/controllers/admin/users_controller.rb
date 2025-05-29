class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def show
    @user = User.find(params[:id])
  end

  def withdraw
    @user = User.find(params[:id])
    if @user.update(is_active: false)
      flash[:notice] = "退会処理を実行しました"
    else
      flash[:alert] = "退会処理に失敗しました"
    end
    redirect_to admin_user_path(@user)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "ユーザー情報を更新しました"
      redirect_to admin_user_path(@user)
    else
      flash.now[:alert] = "ユーザー情報の更新に失敗しました。入力内容をご確認ください。"
      render :edit
    end
  end

  private

  def user_params
    permitted = params.require(:user).permit(
      :last_name,
      :first_name,
      :last_name_kana,
      :first_name_kana,
      :nickname,
      :email,
      :phone_number,
      :prefecture_id,
      :profile_image,
      :is_active
    ).to_h

    # "true"/"false" を boolean に変換
    permitted[:is_active] = ActiveModel::Type::Boolean.new.cast(permitted[:is_active])

    permitted
  end
end
