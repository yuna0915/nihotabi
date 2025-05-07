# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  def after_sign_in_path_for(resource)
    users_my_page_path 
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    email = sign_in_params[:email]
    password = sign_in_params[:password]
    user = User.find_by(email: email)
  
    self.resource = resource_class.new # 空のリソースを用意
  
    if email.blank? || password.blank?
      resource.errors.add(:base, "正しく入力してください")
    elsif user.nil? || !user.valid_password?(password)
      resource.errors.add(:base, "ご入力されたメールアドレスまたはパスワードが正しくありません")
    else
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, user)
      return redirect_to after_sign_in_path_for(user)
    end
  
    clean_up_passwords(resource)
    render :new, status: :unprocessable_entity
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
