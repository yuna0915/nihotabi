class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    respond_to do |format|
      current_user.follow(@user)
      format.js
      format.html { redirect_back fallback_location: root_path }
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    respond_to do |format|
      current_user.unfollow(@user)
      format.js
      format.html { redirect_back fallback_location: root_path }
    end
  end
end
