class Admin::InquiryRepliesController < ApplicationController
  before_action :authenticate_admin!

  def create
    @inquiry = Inquiry.find(params[:inquiry_reply][:inquiry_id])  # 該当のお問い合わせ取得
    @reply = @inquiry.inquiry_replies.build(reply_params)         # 問い合わせに紐づく返信作成
    @reply.admin = current_admin

    if @reply.save
      @inquiry.update(is_checked: true)  # 既読フラグ更新

      # ユーザーの通知作成
      Notification.create!(
        user_id: @inquiry.user_id,            # 通知に関係するユーザー
        notified_user_id: @inquiry.user_id,   # 実際に通知を受け取るユーザー
        action: "inquiry_reply",              # 通知の種類
        notifiable: @reply                    # 通知の対象
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
