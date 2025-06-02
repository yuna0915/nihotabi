class ApplicationController < ActionController::Base
  # セキュリティ対策（不正なフォーム送信を防ぐ）
  protect_from_forgery with: :exception
  # Deviseの追加許可パラメータ設定
  before_action :configure_permitted_parameters, if: :devise_controller?
  # 管理者とユーザーの同時ログイン防止
  before_action :sign_out_conflicting_resource
  # IPアドレスで直接アクセスしても、画面が表示されるようにする
  before_action :allow_http_origin_for_ip

  protected

  # Devise登録・更新時の追加パラメータ
  def configure_permitted_parameters
    added_attrs = [
      :last_name,
      :first_name,
      :last_name_kana,
      :first_name_kana,
      :nickname,
      :phone_number,
      :prefecture_id
    ]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  private

  # 管理者・ユーザー切替
  def sign_out_conflicting_resource
    if controller_path.start_with?("admin/") && user_signed_in?
      sign_out(:user)  # 管理ページではユーザーをログアウト
    elsif !controller_path.start_with?("admin/") && admin_signed_in?
      sign_out(:admin) # ユーザーページでは管理者をログアウト
    end
  end

  # IPアドレスでアクセスされたときに、画面の表示エラーを防ぐための設定
  def allow_http_origin_for_ip
    if request.remote_ip == '13.230.105.193' || request.host == '13.230.105.193'
      response.headers['X-CSRF-Token'] = form_authenticity_token
    end
  end
end
