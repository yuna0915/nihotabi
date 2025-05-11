class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @users = User.all
    @users = User.where.not(email: 'guest@example.com')
  end
end
