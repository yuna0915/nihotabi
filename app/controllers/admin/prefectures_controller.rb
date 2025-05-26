class Admin::PrefecturesController < ApplicationController
  before_action :authenticate_admin!

  def edit
    @prefectures = Prefecture.order(:id)
    @new_prefecture = Prefecture.new
  end

  def create
    @new_prefecture = Prefecture.new(prefecture_params)
    if @new_prefecture.save
      redirect_to admin_edit_prefectures_path, notice: "都道府県を追加しました"
    else
      @prefectures = Prefecture.order(:id)
      render :edit
    end
  end

  def update
    prefecture = Prefecture.find(params[:id])
    if prefecture.update(prefecture_params)
      redirect_to admin_edit_prefectures_path, notice: "都道府県を更新しました"
    else
      redirect_to admin_edit_prefectures_path, alert: "更新失敗"
    end
  end

  def destroy
    prefecture = Prefecture.find(params[:id])
    prefecture.destroy
    redirect_to admin_edit_prefectures_path, notice: "都道府県を削除しました"
  end

  def toggle_active
     # 表示／非表示フラグの切り替え処理（is_activeを反転）
    prefecture = Prefecture.find(params[:id])
    prefecture.update(is_active: !prefecture.is_active)
    redirect_to admin_edit_prefectures_path, notice: "表示状態を変更しました"
  end

  private

  def prefecture_params
    params.require(:prefecture).permit(:name)
  end
end
