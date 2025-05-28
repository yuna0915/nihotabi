class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.page(params[:page]).per(10)

    # 未読の通知をすべて既読に更新
    @notifications.where(is_checked: false).each do |notification|
      notification.update(is_checked: true)
    end
  end

  def mark_as_read
    @notification = current_user.passive_notifications.find(params[:id])
    @notification.update(is_checked: true)

    case @notification.action
    when 'favorite', 'comment'
      redirect_to post_path(@notification.post, from: 'notification')
    when 'follow'
      redirect_to user_path(@notification.user)
    when 'inquiry_reply'
      if @notification.notifiable&.inquiry.present?
        redirect_to inquiry_path(@notification.notifiable.inquiry, from: 'notification')
      else
        redirect_to notifications_path, alert: "対象のお問い合わせが見つかりませんでした。"
      end
    else
      redirect_to notifications_path
    end
  end

  def mark_all_as_read
    current_user.passive_notifications.update_all(is_checked: true)
    redirect_to notifications_path, notice: "すべての通知を既読にしました。"
  end
end
