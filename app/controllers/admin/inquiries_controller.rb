class Admin::InquiriesController < ApplicationController
  before_action :authenticate_admin!

  # 一覧表示
  def index
    @inquiries = Inquiry.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
  end  

  # 詳細表示（+返信投稿用フォーム）
  def show
    @inquiry = Inquiry.find(params[:id])
    @replies = @inquiry.inquiry_replies.includes(:admin)
    @reply = InquiryReply.new
  end
end
