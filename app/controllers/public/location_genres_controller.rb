class Public::LocationGenresController < ApplicationController
  def show
    @location_genre = LocationGenre.find(params[:id])
    @posts = @location_genre.posts.includes(:user).order(created_at: :desc)
  end
end
