class Public::CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      @comment.create_notification_comment!(current_user, @post.user) if @post.user != current_user
  
      redirect_to post_path(@post), notice: 'コメントを投稿しました'
    else
      redirect_to post_path(@post), alert: 'コメントの投稿に失敗しました'
    end
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      flash[:notice] = "コメントを削除しました"
    else
      flash[:alert] = "削除できません"
    end
    redirect_to post_path(@post)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
