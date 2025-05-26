class Admin::VisitedTimeZonesController < ApplicationController
  before_action :authenticate_admin!

  def edit
    @visited_time_zones = VisitedTimeZone.order(:id)
    @new_visited_time_zone = VisitedTimeZone.new
  end

  def create
    @new_visited_time_zone = VisitedTimeZone.new(visited_time_zone_params)
    if @new_visited_time_zone.save
      redirect_to admin_edit_visited_time_zones_path, notice: "時間帯を追加しました"
    else
      @visited_time_zones = VisitedTimeZone.order(:id)
      render :edit
    end
  end

  def update
    zone = VisitedTimeZone.find(params[:id])
    if zone.update(visited_time_zone_params)
      redirect_to admin_edit_visited_time_zones_path, notice: "時間帯を更新しました"
    else
      redirect_to admin_edit_visited_time_zones_path, alert: "更新に失敗しました"
    end
  end

  def destroy
    zone = VisitedTimeZone.find(params[:id])
    zone.destroy
    redirect_to admin_edit_visited_time_zones_path, notice: "時間帯を削除しました"
  end

  def toggle_active
    # 表示／非表示の切り替え処理
    zone = VisitedTimeZone.find(params[:id])
    zone.update(is_active: !zone.is_active)
    redirect_to admin_edit_visited_time_zones_path, notice: "表示状態を変更しました"
  end

  private

  def visited_time_zone_params
    params.require(:visited_time_zone).permit(:hour)
  end
end
