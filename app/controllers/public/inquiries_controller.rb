class Public::InquiriesController < ApplicationController
  before_action :authenticate_user!

  # 他ユーザーの問い合わせを弾く
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  # 一覧表示
  def index
    @inquiries = current_user.inquiries.order(created_at: :desc).page(params[:page]).per(10)
  end  

  # 詳細表示（+返信）
  def show
    @inquiry = current_user.inquiries.find(params[:id])
    @replies = @inquiry.inquiry_replies.includes(:admin)
  end

  # 新規作成フォーム
  def new
    @inquiry = Inquiry.new
  end

  # 作成処理
  def create
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

  # 他人のデータ参照を防ぐ
  def handle_not_found
    redirect_to my_page_user_path(current_user), alert: "不正アクセスです。"
  end
end
