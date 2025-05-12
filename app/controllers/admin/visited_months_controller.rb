class Admin::VisitedMonthsController < ApplicationController
  before_action :authenticate_admin!

  def edit
    @visited_months = VisitedMonth.order(:id)
    @new_visited_month = VisitedMonth.new
  end

  def create
    @new_visited_month = VisitedMonth.new(visited_month_params)
    if @new_visited_month.save
      redirect_to admin_edit_visited_months_path, notice: "訪問月を追加しました"
    else
      @visited_months = VisitedMonth.order(:id)
      render :edit
    end
  end

  def update
    month = VisitedMonth.find(params[:id])
    if month.update(visited_month_params)
      redirect_to admin_edit_visited_months_path, notice: "訪問月を更新しました"
    else
      redirect_to admin_edit_visited_months_path, alert: "更新に失敗しました"
    end
  end

  def destroy
    month = VisitedMonth.find(params[:id])
    month.destroy
    redirect_to admin_edit_visited_months_path, notice: "訪問月を削除しました"
  end

  def toggle_active
    month = VisitedMonth.find(params[:id])
    month.update(is_active: !month.is_active)
    redirect_to admin_edit_visited_months_path, notice: "表示状態を変更しました"
  end

  private

  def visited_month_params
    params.require(:visited_month).permit(:number)
  end
end 
