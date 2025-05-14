# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  def new
    self.resource = resource_class.new
    super
  end

  def create
    email = params[:admin][:email]
    password = params[:admin][:password]
    user = Admin.find_by(email: email)
  
    self.resource = resource_class.new
  
    if email.blank? || password.blank?
      resource.errors.add(:base, "メールアドレスとパスワードを入力してください。")
      flash.now[:alert] = "入力に不備があります。"
    elsif user.nil? || !user.valid_password?(password)
      resource.errors.add(:base, "メールアドレスまたはパスワードが正しくありません。")
      flash.now[:alert] = "ログインに失敗しました。"
    else
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, user)
      return redirect_to after_sign_in_path_for(user)
    end
  
    render :new, status: :unprocessable_entity
  end
  

  protected

  def after_sign_in_path_for(resource_or_scope)
    admin_root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    admin_session_path
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
