class Admin::InquiriesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @inquiries = Inquiry.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
  end  

  def show
    # 問い合わせ詳細＋返信一覧＋新規返信フォーム用変数
    @inquiry = Inquiry.find(params[:id])                   # 該当のお問い合わせ
    @replies = @inquiry.inquiry_replies.includes(:admin)   # 管理者返信（管理者情報も取得）
    @reply = InquiryReply.new                              # フォーム用の空オブジェクト
  end
end
