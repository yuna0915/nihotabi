class Admin::LocationGenresController < ApplicationController
  before_action :authenticate_admin!

  def edit
    @location_genres = LocationGenre.order(:id)
    @new_location_genre = LocationGenre.new
  end

  def create
    @new_location_genre = LocationGenre.new(location_genre_params)
    if @new_location_genre.save
      redirect_to admin_edit_location_genres_path, notice: "ジャンルを追加しました"
    else
      @location_genres = LocationGenre.order(:id)
      render :edit
    end
  end

  def update
    genre = LocationGenre.find(params[:id])
    if genre.update(location_genre_params)
      redirect_to admin_edit_location_genres_path, notice: "ジャンルを更新しました"
    else
      redirect_to admin_edit_location_genres_path, alert: "更新に失敗しました"
    end
  end

  def destroy
    genre = LocationGenre.find(params[:id])
    genre.destroy
    redirect_to admin_edit_location_genres_path, notice: "ジャンルを削除しました"
  end

  def toggle_active
    genre = LocationGenre.find(params[:id])
    genre.update(is_active: !genre.is_active)
    redirect_to admin_edit_location_genres_path, notice: "表示状態を変更しました"
  end

  private

  def location_genre_params
    params.require(:location_genre).permit(:name)
  end
end