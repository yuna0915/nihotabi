class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :sign_out_conflicting_resource

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :last_name,
      :first_name,
      :last_name_kana,
      :first_name_kana,
      :nickname,
      :phone_number,
      :prefecture
    ])
  end

  private

  def sign_out_conflicting_resource
    if controller_path.start_with?("admin/") && user_signed_in?
      sign_out(:user)
    elsif !controller_path.start_with?("admin/") && admin_signed_in?
      sign_out(:admin)
    end
  end
end
