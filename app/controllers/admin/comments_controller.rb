class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @comments = case params[:sort]
                when 'name'  # ← パラメータ名を 'kana' から 'name' に変えるとわかりやすい
                  Comment.joins(:user)
                         .includes(:post)
                         .order('users.last_name ASC, users.first_name ASC')
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
