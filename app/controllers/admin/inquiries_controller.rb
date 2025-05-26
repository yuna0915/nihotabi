class Admin::InquiriesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @inquiries = Inquiry.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
  end  

  def show
    @inquiry = Inquiry.find(params[:id])
    @replies = @inquiry.inquiry_replies.includes(:admin)
    @reply = InquiryReply.new
  end
end
