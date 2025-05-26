class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @users = case params[:sort]
             when 'name'
               User.where.not(email: 'guest@example.com')   # ゲストユーザー除外
                   .order(:last_name, :first_name)          # 名前順（姓→名）
             else
               User.where.not(email: 'guest@example.com')   # 新着順
                   .order(created_at: :desc)
             end

    @users = @users.page(params[:page]).per(10)
  end
end
