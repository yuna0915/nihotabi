class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @comments = case params[:sort]
                when 'aiueo'
                  Comment.includes(:user, :post)
                         .order(:body) # ← これだけでOK！
                         .page(params[:page]).per(10)
                else
                  Comment.includes(:user, :post)
                         .order(created_at: :desc)
                         .page(params[:page]).per(10)
                end
  end  

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to admin_comments_path, notice: "コメントを削除しました"
  end
end
