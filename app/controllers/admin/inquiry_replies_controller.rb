class Admin::InquiryRepliesController < ApplicationController
  before_action :authenticate_admin!

  def create
    @inquiry = Inquiry.find(params[:inquiry_reply][:inquiry_id])  # 該当のお問い合わせ取得
    @reply = @inquiry.inquiry_replies.build(reply_params)         # 問い合わせに紐づく返信作成
    @reply.admin = current_admin                                  # 管理者情報を紐づけ

    if @reply.save
      @inquiry.update(is_checked: true)                           # 問い合わせ側に既読フラグを付ける

      # 通知を1件だけ作成（重複防止済み）
      Notification.create!(
        user_id: current_admin.id,
        notified_user_id: @inquiry.user.id,
        notifiable: @reply,
        action: 'inquiry_reply'
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
