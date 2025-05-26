# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  def after_sign_in_path_for(resource)
    flash[:notice] = "ログインしました。"
    my_page_user_path(resource.id)
  end

  def after_sign_out_path_for(resource_or_scope)
    case params[:redirect_to]
    when "sign_up"
      flash[:notice] = "新規登録画面へ移動しました。"
      new_user_registration_path
    when "login"
      flash[:notice] = "ログイン画面へ移動しました。"
      new_user_session_path
    else
      flash[:notice] = "ログアウトしました。"
      root_path
    end
  end

  # POST /resource/sign_in
  def create
    email = sign_in_params[:email]
    password = sign_in_params[:password]
    user = User.find_by(email: email)
  
    self.resource = resource_class.new # 空のリソースを用意
  
    if email.blank? || password.blank?
      # 未入力チェック
      resource.errors.add(:base, "正しく入力してください")
      flash.now[:alert] = "メールアドレスとパスワードを入力してください。"
    elsif user.nil? || !user.valid_password?(password)
      # 認証失敗（ユーザーがいない or パスワード違い）
      resource.errors.add(:base, "ご入力されたメールアドレスまたはパスワードが正しくありません")
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません。"
    elsif !user.is_active?
      resource.errors.add(:base, "退会済みのアカウントです。")
      flash.now[:alert] = "このアカウントは退会済みです。"
    else
      flash[:notice] = "ログインしました。"
      sign_in(resource_name, user)
      return redirect_to after_sign_in_path_for(user)
    end
  
      clean_up_passwords(resource)                # 入力失敗時、パスワード欄を空にして再表示
      render :new, status: :unprocessable_entity  # エラー付きでログイン画面をもう一度表示

  end

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to my_page_user_path(user), notice: "ゲストユーザーでログインしました。"
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
