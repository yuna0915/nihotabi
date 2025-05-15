class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    respond_to do |format|
      format.js
      format.html { redirect_back fallback_location: root_path }
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    respond_to do |format|
      format.js
      format.html { redirect_back fallback_location: root_path }
    end
  end

end
