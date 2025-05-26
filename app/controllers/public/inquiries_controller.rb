class Public::InquiriesController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]

  def index
    @inquiries = current_user.inquiries.order(created_at: :desc).page(params[:page]).per(10)
  end  

  def show
    @inquiry = current_user.inquiries.find(params[:id])
    @replies = @inquiry.inquiry_replies.includes(:admin)
  end

  def new
    @inquiry = Inquiry.new
  end

  def create
    if !user_signed_in? || current_user.email == "guest@example.com"
      redirect_to new_inquiry_path, alert: "お問い合わせを送信するにはログインまたは会員登録が必要です。"
      return
    end

    @inquiry = current_user.inquiries.build(inquiry_params)
    if @inquiry.save
      redirect_to inquiries_path, notice: "お問い合わせを送信しました。"
    else
      flash.now[:alert] = "件名と内容を入力してください。"
      render :new
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:title, :body)
  end
end
