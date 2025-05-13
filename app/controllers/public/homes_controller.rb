class Public::HomesController < ApplicationController
  def top
    @latest_posts = Post.includes(:user).order(created_at: :desc).limit(4)
  end

  def about
  end
end
