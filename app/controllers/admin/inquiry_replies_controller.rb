class Admin::InquiryRepliesController < ApplicationController
  before_action :authenticate_admin!

  def create
    @inquiry = Inquiry.find(params[:inquiry_reply][:inquiry_id])
    @reply = @inquiry.inquiry_replies.build(reply_params)
    @reply.admin = current_admin

    if @reply.save
      # 既読フラグを更新
      @inquiry.update(is_checked: true)

      # 通知作成（ユーザーに返信通知を送信）
      Notification.create!(
        user_id: @inquiry.user_id,                # 作成者（管理者が返信するので空でも可）
        notified_user_id: @inquiry.user_id,       # 通知の受け取り手（ユーザー）
        action: "inquiry_reply",                  # 通知種別
        notifiable: @reply                        # 通知対象（InquiryReply）
      )

      redirect_to admin_inquiry_path(@inquiry), notice: "返信を送信しました。"
    else
      flash.now[:alert] = "返信内容を入力してください。"
      @replies = @inquiry.inquiry_replies.includes(:admin)
      render "admin/inquiries/show"
    end
  end

  private

  def reply_params
    params.require(:inquiry_reply).permit(:body)
  end
end
