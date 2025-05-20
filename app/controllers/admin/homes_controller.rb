class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @users = case params[:sort]
             when 'name'
               User.where.not(email: 'guest@example.com')
                   .order(:last_name, :first_name)
             else
               User.where.not(email: 'guest@example.com')
                   .order(created_at: :desc)
             end

    @users = @users.page(params[:page]).per(10)
  end
end
