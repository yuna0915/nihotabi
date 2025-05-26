class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, dependent: :destroy

  validates :body, presence: true

  # コメント作成後に通知を生成
  after_create :create_notification

  private
 
  # 投稿者とコメント投稿者が違う場合に通知を作成
  def create_notification
   return if post.user == user  # 自分の投稿には通知を送らない
 
     Notification.create!(
      user_id: user.id,                   # コメントしたユーザー
      notified_user_id: post.user.id,     # 通知を受け取るユーザー
      post_id: post.id,                   # 関連する投稿
      comment_id: id,                     # 関連するコメント
      action: 'comment'                   # 通知の種類（コメント）
    )
  end
end