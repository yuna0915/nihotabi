class Public::LocationGenresController < ApplicationController
  def show
    @location_genre = LocationGenre.find(params[:id])
    @posts = @location_genre.posts.includes(:user).sorted(params[:sort]).page(params[:page])
  end
end
